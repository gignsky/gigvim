# Embedded Language Support Configuration
# Enables LSP and syntax highlighting for embedded Lua and Bash code within Nix files

{ pkgs, ... }:
{
  config.vim = {
    # Custom Lua configuration for treesitter injections and otter-nvim
    luaConfigRC.embedded-languages = ''
      -- Configure treesitter injections for Nix files
      
      -- Generic treesitter injections for embedded languages in Nix
      -- This uses more generic patterns that automatically detect common embedded code patterns
      
      -- Generic injection for quoted string blocks that look like Lua
      vim.treesitter.query.set("nix", "injections", [[
        ; Generic Lua injection for setup/config strings
        (indented_string_expression
          (string_fragment) @injection.content
          (#lua-match? @injection.content "^%s*require%s*%(" )
          (#set! injection.language "lua"))
          
        ; Generic Lua injection for function/method calls
        (indented_string_expression
          (string_fragment) @injection.content
          (#lua-match? @injection.content "function%s*%(" )
          (#set! injection.language "lua"))
          
        ; Generic Lua injection for vim/nvim API calls
        (indented_string_expression
          (string_fragment) @injection.content
          (#lua-match? @injection.content "vim%." )
          (#set! injection.language "lua"))
      ]])
      
      -- Generic injection for shell script patterns
      vim.treesitter.query.set("nix", "injections", [[
        ; Generic bash injection for shell scripts (shebang)
        (indented_string_expression
          (string_fragment) @injection.content
          (#lua-match? @injection.content "^%s*#!/.*sh" )
          (#set! injection.language "bash"))
          
        ; Generic bash injection for common shell commands
        (indented_string_expression
          (string_fragment) @injection.content
          (#lua-match? @injection.content "^%s*echo%s+" )
          (#set! injection.language "bash"))
          
        ; Generic bash injection for shell constructs
        (indented_string_expression
          (string_fragment) @injection.content
          (#lua-match? @injection.content "if%s+%[" )
          (#set! injection.language "bash"))
      ]])
      
      -- Generic injection for nushell patterns
      vim.treesitter.query.set("nix", "injections", [[
        ; Generic nushell injection for def functions
        (indented_string_expression
          (string_fragment) @injection.content
          (#lua-match? @injection.content "^%s*def%s+" )
          (#set! injection.language "nu"))
          
        ; Generic nushell injection for let declarations  
        (indented_string_expression
          (string_fragment) @injection.content
          (#lua-match? @injection.content "^%s*let%s+%w+%s*=" )
          (#set! injection.language "nu"))
          
        ; Generic nushell injection for pipe operations
        (indented_string_expression
          (string_fragment) @injection.content
          (#lua-match? @injection.content "%|%s*%w+" )
          (#set! injection.language "nu"))
          
        ; Generic nushell injection for $in variables
        (indented_string_expression
          (string_fragment) @injection.content
          (#lua-match? @injection.content "%$in" )
          (#set! injection.language "nu"))
      ]])

      -- Note: otter-nvim is already enabled in lang/default.nix, so we don't need to setup again

      -- Auto-activation for Nix files with embedded languages
      -- Generic detection based on content patterns
      vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {
        pattern = {"*.nix"},
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          local content = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
          
          local languages = {}
          
          -- Generic Lua detection (more patterns)
          if content:match("require%s*%(") or 
             content:match("function%s*%(") or 
             content:match("vim%.") or
             content:match("local%s+%w+") or
             content:match("setup%s*=") then
            table.insert(languages, "lua")
          end
          
          -- Generic Bash detection (more patterns)  
          if content:match("#!/.*sh") or
             content:match("echo%s+") or
             content:match("if%s+%[") or
             content:match("writeShellScript") or
             content:match("for%s+%w+%s+in") then
            table.insert(languages, "bash")
          end
          
          -- Generic Nushell detection
          if content:match("def%s+") or
             content:match("let%s+%w+%s*=") or
             content:match("|%s*%w+") or
             content:match("$in") or
             content:match("%.nu") then
            table.insert(languages, "nu")
          end
          
          -- Activate otter if we found embedded languages
          if #languages > 0 then
            require('otter').activate(languages, true, true, nil)
            -- Optional: Display activation message
            vim.notify("Activated otter for: " .. table.concat(languages, ", "), vim.log.levels.INFO)
          end
        end,
      })

      -- Add keybindings for otter functionality
      vim.keymap.set('n', '<leader>lo', '<cmd>lua require("otter").activate()<cr>', { desc = "Activate Otter" })
      vim.keymap.set('n', '<leader>ld', '<cmd>lua require("otter").deactivate()<cr>', { desc = "Deactivate Otter" })
      vim.keymap.set('n', '<leader>lr', '<cmd>lua require("otter").ask_rename()<cr>', { desc = "Otter Rename" })
      vim.keymap.set('n', '<leader>lf', '<cmd>lua require("otter").ask_format()<cr>', { desc = "Otter Format" })
      
      -- Debug helper to show active otter buffers
      vim.keymap.set('n', '<leader>li', '<cmd>lua print(vim.inspect(require("otter").get_status()))<cr>', { desc = "Otter Info" })
      
      -- Context-aware commenting function that respects embedded language
      local function context_aware_comment()
        local otter = require('otter')
        local current_line = vim.api.nvim_get_current_line()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local col = cursor_pos[2]
        
        -- Try to get the language at current cursor position
        local otter_lang = nil
        local status = otter.get_status()
        if status and status.languages and #status.languages > 0 then
          -- Check if we're in an embedded language region
          local ts_utils = require('nvim-treesitter.ts_utils')
          local node = ts_utils.get_node_at_cursor()
          if node then
            local start_row, start_col, end_row, end_col = node:range()
            -- Simple heuristic: if we're in a string that otter is managing, use embedded language
            for _, lang in ipairs(status.languages) do
              otter_lang = lang
              break
            end
          end
        end
        
        -- Set comment string based on detected language
        local comment_string = "#"  -- Default for Nix
        if otter_lang == "lua" then
          comment_string = "--"
        elseif otter_lang == "bash" then  
          comment_string = "#"
        elseif otter_lang == "nu" then
          comment_string = "#"
        end
        
        -- Apply commenting
        if current_line:match("^%s*" .. vim.pesc(comment_string)) then
          -- Uncomment
          local new_line = current_line:gsub("^(%s*)" .. vim.pesc(comment_string) .. "%s?", "%1")
          vim.api.nvim_set_current_line(new_line)
        else
          -- Comment
          local indent = current_line:match("^%s*")
          local content = current_line:sub(#indent + 1)
          if content ~= "" then
            vim.api.nvim_set_current_line(indent .. comment_string .. " " .. content)
          end
        end
      end
      
      -- Override default commenting with context-aware version
      vim.keymap.set('n', 'gc', context_aware_comment, { desc = "Context-aware comment toggle" })
      vim.keymap.set('v', 'gc', function()
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")
        for line_num = start_line, end_line do
          vim.api.nvim_win_set_cursor(0, {line_num, 0})
          context_aware_comment()
        end
      end, { desc = "Context-aware comment toggle (visual)" })
      
      -- Enhanced LSP evaluation for embedded code blocks
      local function evaluate_embedded_code()
        local otter = require('otter')
        local status = otter.get_status()
        
        if not status or not status.languages or #status.languages == 0 then
          vim.notify("No embedded languages detected", vim.log.levels.WARN)
          return
        end
        
        local current_line = vim.api.nvim_get_current_line()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        
        -- Get visual selection or current line
        local lines = {}
        local mode = vim.fn.mode()
        if mode == 'v' or mode == 'V' then
          local start_line = vim.fn.line("'<")
          local end_line = vim.fn.line("'>")
          lines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)
        else
          lines = {current_line}
        end
        
        local code = table.concat(lines, "\n")
        
        -- Try to evaluate based on detected language
        for _, lang in ipairs(status.languages) do
          if lang == "lua" then
            -- Lua evaluation
            local ok, result = pcall(loadstring, code)
            if ok and result then
              local exec_ok, exec_result = pcall(result)
              if exec_ok then
                vim.notify("Lua code executed successfully", vim.log.levels.INFO)
                if exec_result then
                  print("Result:", vim.inspect(exec_result))
                end
              else
                vim.notify("Lua execution error: " .. tostring(exec_result), vim.log.levels.ERROR)
              end
            else
              vim.notify("Lua syntax error: " .. tostring(result), vim.log.levels.ERROR)
            end
          elseif lang == "bash" then
            -- Bash validation using shellcheck if available
            local cmd = "echo " .. vim.fn.shellescape(code) .. " | shellcheck -f json -"
            vim.fn.jobstart(cmd, {
              stdout_buffered = true,
              on_stdout = function(_, data)
                if data and #data > 1 then
                  local json = table.concat(data, "\n")
                  local ok, parsed = pcall(vim.json.decode, json)
                  if ok and parsed and #parsed > 0 then
                    for _, issue in ipairs(parsed) do
                      vim.notify(string.format("Shellcheck %s: %s (line %d)", 
                        issue.level, issue.message, issue.line), vim.log.levels.WARN)
                    end
                  else
                    vim.notify("Bash code looks good (shellcheck)", vim.log.levels.INFO)
                  end
                else
                  vim.notify("Bash code validation completed", vim.log.levels.INFO)
                end
              end,
              on_stderr = function(_, data)
                if data and #data > 1 then
                  vim.notify("Shellcheck not available", vim.log.levels.WARN)
                end
              end
            })
          elseif lang == "nu" then
            -- Nushell validation (basic syntax check)
            vim.notify("Nushell syntax validation not yet implemented", vim.log.levels.INFO)
          end
        end
      end
      
      -- Add keybinding for code evaluation
      vim.keymap.set({'n', 'v'}, '<leader>le', evaluate_embedded_code, { desc = "Evaluate embedded code" })
    '';
  };
}