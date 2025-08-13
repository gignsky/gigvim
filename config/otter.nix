# Otter Configuration for Embedded Language Support
# Provides otter-nvim functionality for embedded languages

{ pkgs, ... }:
{
  config.vim = {
    # Enable otter-nvim for embedded language support
    lsp.otter-nvim.enable = true;

    # Additional otter configuration via extraPlugins for auto-activation
    extraPlugins = {
      otter-config = {
        package = pkgs.vimUtils.buildVimPlugin {
          name = "otter-auto-config";
          src = pkgs.writeText "otter-auto-config" "";
        };
        setup = ''
          -- Auto-activate otter for Nix files with embedded languages
          local otter = require('otter')
          
          -- Configuration for embedded language detection
          local embedded_languages = {
            "lua",      -- Lua in plugin setup strings
            "bash",     -- Bash in writeShellScriptBin
            "sh",       -- Alternative shell detection
          }
          
          -- Auto-activate otter for specific file patterns
          vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
            pattern = "*.nix",
            callback = function()
              local bufnr = vim.api.nvim_get_current_buf()
              local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
              
              -- Check for embedded language patterns
              local has_embedded = false
              
              -- Pattern 1: Lua in setup strings (extraPlugins setup = ''...'' or similar)
              if content:match('setup%s*=%s*[\'"`][\'"`][\'"`]') or 
                 content:match('require%s*%([\'"`][^\'"`]+[\'"`]%)') or
                 content:match('vim%.') or
                 content:match('function%s*%(') then
                has_embedded = true
              end
              
              -- Pattern 2: Bash in writeShellScriptBin or shell strings
              if content:match('writeShellScriptBin') or
                 content:match('writeShellScript') or
                 content:match('#!/bin/bash') or
                 content:match('#!/bin/sh') or
                 content:match('echo%s+') then
                has_embedded = true
              end
              
              -- Activate otter if embedded languages detected
              if has_embedded then
                pcall(function()
                  otter.activate(embedded_languages, true, true, nil)
                end)
              end
            end,
          })
          
          -- Enhanced otter setup with better language detection
          otter.setup({
            -- Enable verbose logging for debugging
            verbose = {
              no_code_found = false,
            },
            -- Language detection settings
            buffers = {
              -- Set a reasonable limit on the number of lines to scan
              set_filetype = true,
              write_to_disk = false,
            },
            -- Handle completion in embedded languages
            handle_leading_whitespace = true,
          })
          
          -- Additional keybinding for quick activation with language selection
          vim.keymap.set('n', '<leader>lL', function()
            otter.activate(embedded_languages, true, true, nil)
            vim.notify("Otter activated for: " .. table.concat(embedded_languages, ", "))
          end, { desc = 'Activate Otter with all languages' })
        '';
      };
    };
  };
}