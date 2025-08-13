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
      
      -- Enhanced injection for Lua code in setup strings
      vim.treesitter.query.set("nix", "injections", [[
        ; Lua injection for setup = ''' ... ''' (primary pattern)
        (binding
          attrpath: (attrpath (identifier) @_key (#eq? @_key "setup"))
          expression: (indented_string_expression 
            (string_fragment) @injection.content)
          (#set! injection.language "lua"))
          
        ; Lua injection for nested setup in extraPlugins
        (apply_expression
          function: (select_expression
            attrpath: (attrpath (identifier) @_setup (#eq? @_setup "setup")))
          argument: (indented_string_expression 
            (string_fragment) @injection.content)
          (#set! injection.language "lua"))
      ]])
      
      -- Enhanced injection for Bash code in writeShellScriptBin
      vim.treesitter.query.set("nix", "injections", [[
        ; Bash injection for writeShellScriptBin "name" ''' ... '''
        (apply_expression
          function: (select_expression
            expression: (variable) @_pkgs (#eq? @_pkgs "pkgs")
            attrpath: (attrpath (identifier) @_func (#eq? @_func "writeShellScriptBin")))
          argument: [
            (string_expression)
            (indented_string_expression 
              (string_fragment) @injection.content)
          ]
          (#set! injection.language "bash"))
          
        ; Alternative pattern for writeShellScriptBin with immediate string
        (apply_expression
          function: (select_expression
            expression: (variable) @_pkgs (#eq? @_pkgs "pkgs")
            attrpath: (attrpath (identifier) @_func (#eq? @_func "writeShellScriptBin")))
          argument: (indented_string_expression 
            (string_fragment) @injection.content)
          (#set! injection.language "bash"))
      ]])

      -- Configure otter-nvim for multi-language support
      require('otter').setup({
        lsp = {
          hover = {
            border = "rounded",
          },
        },
        buffers = {
          set_filetype = true,
        },
        handle_leading_whitespace = true,
      })

      -- Auto-activation for Nix files with embedded languages
      -- This provides a fallback even if treesitter injections don't work perfectly
      vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {
        pattern = {"*.nix"},
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          local content = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
          
          local languages = {}
          
          -- Check for Lua setup strings (multiple patterns)
          if content:match("setup%s*=%s*''''") or 
             content:match("%.setup%s*''''") or
             content:match("setup%s*=%s*[\"']") then
            table.insert(languages, "lua")
          end
          
          -- Check for Bash writeShellScriptBin
          if content:match("writeShellScriptBin") then
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