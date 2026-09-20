{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;

  # Filetypes whose buffers hold prose rather than code. In these, a line break
  # is the author's punctuation -- placed at a clause or a sentence end -- and
  # nothing but the author should move one.
  proseFiletypes = [
    "asciidoc"
    "context"
    "markdown"
    "org"
    "plaintex"
    "rmd"
    "rst"
    "tex"
    "text"
    "typst"
  ];
in
{
  config.vim = {
    augroups = [
      {
        name = "gigvimProse";
        clear = true;
      }
    ];

    autocmds = [
      {
        event = [ "FileType" ];
        pattern = proseFiletypes;
        group = "gigvimProse";
        desc = "Never let the editor insert a line break into prose";
        callback = mkLuaInline ''
          function()
            -- 't' auto-wraps prose and 'c' auto-wraps comments, both at
            -- 'textwidth', while you are still typing -- so editing a sentence
            -- in the middle of a paragraph silently chops the line the moment
            -- it crosses the limit.
            --
            -- This has to be a FileType autocmd rather than a global option:
            -- Neovim's own ftplugin/markdown.vim does "setlocal
            -- formatoptions+=tcqln", which would undo a global setting. nvf
            -- registers its autocmds from init.lua, after the runtime ftplugins
            -- have been sourced, so this runs last and wins.
            vim.opt_local.formatoptions:remove("t")
            vim.opt_local.formatoptions:remove("c")

            -- 'textwidth' is deliberately left alone. With 't' gone it no
            -- longer wraps anything by itself, and it still gives "gq" a
            -- sensible width on the rare occasion a reflow is actually wanted.

            -- Wrapping becomes a display concern only: fold long lines in the
            -- window, indent the folded part under the paragraph, never touch
            -- the bytes on disk. ('wrap' and 'linebreak' are already on.)
            vim.opt_local.breakindent = true

            -- Spellcheck prose against American English. Neovim's bundled
            -- en.utf-8.spl (nvim-unwrapped's runtime/spell) tags every word
            -- with the regions it's valid in, so "en_us" alone already gives
            -- mostly-American with select Britishisms baked in:
            --   - shared/non-pair words (whilst, amongst, towards, grey,
            --     dialogue, ...) are accepted outright -- no US/GB pair
            --     exists for them, so there's nothing to flag.
            --   - true spelling-pair Britishisms (colour, realise, centre,
            --     travelled, favour, ...) are flagged as SpellLocal (a
            --     regional mismatch, underlined green by default) rather than
            --     SpellBad (underlined red) -- visible, but clearly softer
            --     than a real misspelling.
            -- To fully allow a specific pair-word despite this (elevate it
            -- out of SpellLocal), add it with "zg" -- Neovim writes personal
            -- good-words to a spellfile under the XDG state dir by default,
            -- so it persists outside the Nix store without any config here.
            vim.opt_local.spelllang = "en_us"
            vim.opt_local.spell = true

            -- Word-style interactive spellcheck: <leader>pp steps to the next
            -- misspelling and prompts for what to do with it, rather than
            -- requiring "]s", "z=" and ":spellrepall" to be typed by hand.
            -- Lazily defined once on a global table, same pattern as
            -- GigvimTexWatch in lang/tex.nix, since this FileType callback
            -- re-runs on every prose buffer opened.
            _G.GigvimSpellcheck = _G.GigvimSpellcheck or {}
            local M = _G.GigvimSpellcheck

            if not M.start then
              local function notify(msg, level)
                vim.notify(msg, level or vim.log.levels.INFO, { title = "Spellcheck", timeout = 3000 })
              end

              -- Replace the word under the cursor without touching the rest
              -- of the line. Returns the word that was there, so callers
              -- don't need to re-derive it.
              local function replace_at_cursor(new_word)
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
                local s, e = col + 1, col + 1
                while s > 1 and line:sub(s - 1, s - 1):match("[%w']") do
                  s = s - 1
                end
                while e <= #line and line:sub(e, e):match("[%w']") do
                  e = e + 1
                end
                e = e - 1
                local new_line = line:sub(1, s - 1) .. new_word .. line:sub(e + 1)
                vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
                vim.api.nvim_win_set_cursor(0, { row, s - 1 + #new_word - 1 })
                return line:sub(s, e)
              end

              -- Prompt for the word the cursor is currently sitting on (does
              -- not move the cursor first -- M.step() does that).
              local function prompt_word()
                local bad = vim.fn.spellbadword()
                local word = bad[1] ~= "" and bad[1] or nil
                if not word then
                  notify("no more misspelled words")
                  return
                end

                local items = vim.fn.spellsuggest(word, 8)
                vim.list_extend(items, {
                  "[ignore once]",
                  "[ignore for this session]",
                  "[add to dictionary]",
                  "[stop]",
                })

                vim.ui.select(items, { prompt = ('Spellcheck: "%s"'):format(word) }, function(choice)
                  if not choice or choice == "[stop]" then
                    notify("stopped")
                  elseif choice == "[ignore once]" then
                    M.step()
                  elseif choice == "[ignore for this session]" then
                    vim.cmd("normal! zG")
                    M.step()
                  elseif choice == "[add to dictionary]" then
                    vim.cmd("normal! zg")
                    M.step()
                  else
                    vim.ui.select({ "Change", "Change all", "Cancel" }, {
                      prompt = ('Replace "%s" with "%s"?'):format(word, choice),
                    }, function(scope)
                      if scope == "Change" then
                        replace_at_cursor(choice)
                        M.step()
                      elseif scope == "Change all" then
                        local pat = vim.fn.escape(word, "\\/.*$^~[")
                        local rep = vim.fn.escape(choice, "\\/&~")
                        vim.cmd(("silent! keeppatterns %%s/\\<%s\\>/%s/g"):format(pat, rep))
                        M.step()
                      else
                        -- "Cancel" or <Esc>: re-prompt the same word instead
                        -- of skipping it like [ignore once] would.
                        prompt_word()
                      end
                    end)
                  end
                end)
              end

              -- Advance to the next misspelling (wraps at end of buffer, same
              -- as native "]s") and prompt for it.
              function M.step()
                vim.cmd("silent! normal! ]s")
                prompt_word()
              end

              function M.start()
                vim.cmd("silent! normal! gg")
                M.step()
              end
            end

            vim.keymap.set("n", "<leader>pp", M.start, {
              buffer = true,
              silent = true,
              desc = "Spellcheck: step through document (change/change all/ignore/add)",
            })
          end
        '';
      }
    ];
  };
}
