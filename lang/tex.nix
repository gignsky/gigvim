{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  config.vim = {
    languages.tex = {
      enable = true;
      format = {
        enable = true;
        type = [ "tex-fmt" ];
      };
      lsp.enable = true;
      treesitter.enable = true;
    };

    # tex-fmt wraps at 80 columns by default, so format-on-save reflowed the
    # whole document on every write -- breaking around macros and braces rather
    # than at anything meaningful in the prose. "--nowrap" keeps the useful half
    # (indentation and whitespace normalisation) and leaves line breaks where
    # the author put them: tex-fmt only ever splits over-long lines and never
    # joins lines, so with wrapping off it cannot move a break at all.
    #
    # nvf's tex module sets only `command` on this formatter, so this merges
    # rather than conflicts. conform's built-in tex-fmt entry supplies "-s",
    # giving `tex-fmt --nowrap -s`.
    formatter.conform-nvim.setupOpts.formatters."tex-fmt".prepend_args = [ "--nowrap" ];

    augroups = [
      {
        name = "gigvimTexWatch";
        clear = true;
      }
    ];

    autocmds = [
      {
        event = [ "FileType" ];
        pattern = [ "tex" ];
        group = "gigvimTexWatch";
        desc = "LaTeX live-preview: <leader>vv toggles the just-watch equivalent";
        callback = mkLuaInline ''
          function()
            -- Mirrors this repo's `just watch` recipe (see the `watch` target
            -- in a .tex project's justfile): build with latexmk, open zathura,
            -- rebuild on every save, surface the result as a notification
            -- instead of a terminal line. Lazily defined once on the global
            -- table so state (which buffers are being watched, their jobs)
            -- survives every later FileType=tex firing, which re-runs this
            -- whole callback per buffer.
            _G.GigvimTexWatch = _G.GigvimTexWatch or {}
            local M = _G.GigvimTexWatch

            if not M.toggle then
              M.buffers = {}

              -- snacks.nvim's global notifier timeout is 30s, which is far
              -- too long for a "build finished" ping -- override it per call
              -- here rather than lowering the shared default for everything.
              local function notify(msg, level, timeout)
                vim.notify(msg, level, { title = "LaTeX", timeout = timeout })
              end

              local function stop(bufnr, reason)
                local st = M.buffers[bufnr]
                if not st then
                  return
                end
                M.buffers[bufnr] = nil
                if st.augroup then
                  pcall(vim.api.nvim_del_augroup_by_id, st.augroup)
                end
                if st.build_job then
                  pcall(vim.fn.jobstop, st.build_job)
                end
                if st.viewer_job then
                  pcall(vim.fn.jobstop, st.viewer_job)
                end
                if reason then
                  notify(reason, vim.log.levels.INFO, 3000)
                end
              end

              -- Build once. `on_done` (only passed for the very first build)
              -- is how the viewer gets launched after a PDF actually exists,
              -- rather than racing zathura against the first compile.
              local function build(bufnr, file, dir, log, on_done)
                local st = M.buffers[bufnr]
                if not st or st.build_job then
                  return
                end
                -- nonstopmode: never drop into xelatex's interactive `?`
                -- prompt on an error, same reasoning as the justfile version.
                st.build_job = vim.fn.jobstart(
                  { "latexmk", "-xelatex", "-interaction=nonstopmode", file },
                  {
                    cwd = dir,
                    on_exit = function(_, code)
                      local live = M.buffers[bufnr]
                      if live then
                        live.build_job = nil
                      end
                      if code == 0 then
                        vim.fn.jobstart({ "latexmk", "-c", file }, { cwd = dir, detach = true })
                        notify("built " .. os.date("%H:%M:%S"), vim.log.levels.INFO, 3500)
                      else
                        -- Same excerpt the justfile prints: the first dozen
                        -- unique "!"/"l." lines from the .log, aux files kept.
                        local excerpt, seen = {}, {}
                        if vim.fn.filereadable(log) == 1 then
                          for _, l in ipairs(vim.fn.readfile(log)) do
                            if (l:match("^!") or l:match("^l%.")) and not seen[l] then
                              seen[l] = true
                              table.insert(excerpt, l)
                              if #excerpt >= 12 then
                                break
                              end
                            end
                          end
                        end
                        notify(
                          #excerpt > 0 and table.concat(excerpt, "\n") or "build failed",
                          vim.log.levels.ERROR,
                          9000
                        )
                      end
                      if on_done then
                        on_done(code)
                      end
                    end,
                  }
                )
              end

              function M.toggle()
                local bufnr = vim.api.nvim_get_current_buf()
                if M.buffers[bufnr] then
                  stop(bufnr, "stopped watching " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t"))
                  return
                end

                local file = vim.api.nvim_buf_get_name(bufnr)
                if file == "" then
                  notify("save the file first", vim.log.levels.WARN, 3000)
                  return
                end
                local dir = vim.fn.fnamemodify(file, ":h")
                local log = vim.fn.fnamemodify(file, ":r") .. ".log"
                local pdf = vim.fn.fnamemodify(file, ":r") .. ".pdf"

                local augroup = vim.api.nvim_create_augroup("GigvimTexWatch" .. bufnr, { clear = true })
                M.buffers[bufnr] = { augroup = augroup }

                vim.api.nvim_create_autocmd("BufWritePost", {
                  group = augroup,
                  buffer = bufnr,
                  callback = function()
                    build(bufnr, file, dir, log)
                  end,
                })
                -- Close the loop the user asked for: the PDF (zathura) and
                -- the watcher go down together, whichever side closes first.
                vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout", "VimLeavePre" }, {
                  group = augroup,
                  buffer = bufnr,
                  once = true,
                  callback = function()
                    stop(bufnr)
                  end,
                })

                notify("watching " .. vim.fn.fnamemodify(file, ":t"), vim.log.levels.INFO, 3000)

                build(bufnr, file, dir, log, function()
                  local live = M.buffers[bufnr]
                  if not live or live.viewer_job or vim.fn.filereadable(pdf) == 0 then
                    return
                  end
                  live.viewer_job = vim.fn.jobstart({ "zathura", pdf }, {
                    cwd = dir,
                    -- User closed zathura by hand: stop watching too, instead
                    -- of rebuilding forever with nothing showing it.
                    on_exit = function()
                      stop(bufnr)
                    end,
                  })
                end)
              end
            end

            vim.keymap.set("n", "<leader>vv", M.toggle, {
              buffer = true,
              silent = true,
              desc = "Toggle LaTeX watch (rebuild on save + zathura preview)",
            })
          end
        '';
      }
    ];
  };
}
