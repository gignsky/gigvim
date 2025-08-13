# Embedded Language Support Configuration
# Enables LSP and syntax highlighting for embedded Lua and Bash code within Nix files

{ pkgs, ... }:
{
  config.vim = {
    # Configure treesitter injections for embedded languages in Nix files
    treesitter = {
      grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    };

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
    '';
  };
}