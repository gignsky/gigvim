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
      
      -- Add injection for Lua code in setup strings (using indented_string_expression)
      vim.treesitter.query.set("nix", "injections", [[
        ; Lua injection for setup strings
        (binding
          attrpath: (attrpath (identifier) @_setup (#eq? @_setup "setup"))
          expression: (indented_string_expression 
            (string_fragment) @injection.content)
          (#set! injection.language "lua"))
      ]])
      
      -- Add injection for Bash code in writeShellScriptBin strings
      vim.treesitter.query.set("nix", "injections", [[
        ; Bash injection for writeShellScriptBin with indented strings
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
      vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {
        pattern = {"*.nix"},
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          local content = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
          
          -- Activate otter for files containing setup strings (Lua)
          if content:match("setup%s*=%s*['\"]") or content:match("%.setup%s*['\"]") then
            require('otter').activate({'lua'}, true, true, nil)
          end
          
          -- Activate otter for files containing writeShellScriptBin (Bash)
          if content:match("writeShellScriptBin") then
            require('otter').activate({'bash'}, true, true, nil)
          end
        end,
      })

      -- Add keybindings for otter functionality
      vim.keymap.set('n', '<leader>lo', '<cmd>lua require("otter").activate()<cr>', { desc = "Activate Otter" })
      vim.keymap.set('n', '<leader>ld', '<cmd>lua require("otter").deactivate()<cr>', { desc = "Deactivate Otter" })
      vim.keymap.set('n', '<leader>lr', '<cmd>lua require("otter").ask_rename()<cr>', { desc = "Otter Rename" })
      vim.keymap.set('n', '<leader>lf', '<cmd>lua require("otter").ask_format()<cr>', { desc = "Otter Format" })
    '';
  };
}