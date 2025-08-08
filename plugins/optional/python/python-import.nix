# python-import.nvim Plugin Configuration
# Intelligent Python import management for Neovim
# Repository: https://github.com/kiyoon/python-import.nvim
#
# python-import.nvim provides intelligent import management for Python development,
# including automatic import insertion, import optimization, and import organization.
#
# Features enabled:
# - Automatic import detection and insertion
# - Import statement optimization and sorting
# - Missing import suggestions from LSP
# - Integration with isort for import formatting
# - Support for relative and absolute imports
# - Third-party package import detection
#
# Settings configured:
# - Automatic import on symbol usage
# - Integration with LSP for import suggestions
# - isort configuration for import formatting
# - Keybindings for manual import operations
# - Support for common Python import patterns
#
# Settings still need to be configured:
# - Custom import aliases and shortcuts
# - Project-specific import preferences
# - Integration with custom import sources

{ inputs, pkgs, ... }:
let
  python-import-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "python-import-nvim";
    src = inputs.python-import-nvim;
  };
in
{
  config.vim.extraPlugins = {
    python-import = {
      package = python-import-from-source;
      setup = ''
        require('python-import').setup({
          -- Automatic import detection
          auto_import = {
            enabled = true,
            
            -- Trigger import insertion on undefined symbol
            on_undefined_symbol = true,
            
            -- Delay before showing import suggestions (ms)
            delay = 500,
          },
          
          -- Import sources configuration
          sources = {
            -- Standard library imports
            stdlib = {
              enabled = true,
              priority = 1,
            },
            
            -- Third-party package imports
            packages = {
              enabled = true,
              priority = 2,
              
              -- Common package aliases
              aliases = {
                numpy = "np",
                pandas = "pd",
                matplotlib.pyplot = "plt",
                seaborn = "sns",
                tensorflow = "tf",
                torch = "torch",
                sklearn = "sklearn",
              },
            },
            
            -- Local module imports
            local_modules = {
              enabled = true,
              priority = 3,
              
              -- Search depth for local modules
              max_depth = 3,
            },
            
            -- LSP-based imports
            lsp = {
              enabled = true,
              priority = 4,
              
              -- LSP servers to query for imports
              servers = { "pyright", "pylsp" },
            },
          },
          
          -- Import formatting configuration
          formatting = {
            -- Use isort for import sorting
            use_isort = true,
            
            -- isort configuration
            isort_config = {
              profile = "black",
              multi_line_output = 3,
              line_length = 88,
              known_first_party = {},
              known_third_party = {},
            },
            
            -- Import grouping
            group_imports = true,
            
            -- Remove unused imports
            remove_unused = true,
          },
          
          -- Insertion behavior
          insertion = {
            -- Where to insert imports
            position = "top",  -- "top", "after_docstring", "smart"
            
            -- Preserve existing import order
            preserve_order = false,
            
            -- Add blank line after imports
            add_blank_line = true,
          },
          
          -- UI configuration
          ui = {
            -- Show import preview before insertion
            show_preview = true,
            
            -- Use telescope for import selection
            use_telescope = true,
            
            -- Notification settings
            notifications = {
              enabled = true,
              timeout = 3000,
            },
          },
          
          -- Performance settings
          performance = {
            -- Cache import suggestions
            cache_enabled = true,
            
            -- Cache timeout (seconds)
            cache_timeout = 300,
            
            -- Maximum suggestions to show
            max_suggestions = 20,
          },
        })
        
        -- Key mappings for import operations
        vim.keymap.set('n', '<leader>pi', function()
          require('python-import').auto_import()
        end, { 
          desc = 'Auto-import symbol under cursor',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>pI', function()
          require('python-import').organize_imports()
        end, { 
          desc = 'Organize all imports',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>pf', function()
          require('python-import').find_imports()
        end, { 
          desc = 'Find and insert imports',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>pu', function()
          require('python-import').remove_unused_imports()
        end, { 
          desc = 'Remove unused imports',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>pa', function()
          require('python-import').add_import_alias()
        end, { 
          desc = 'Add import alias',
          silent = true 
        })
        
        -- Visual mode: import selection
        vim.keymap.set('v', '<leader>pi', function()
          require('python-import').import_selection()
        end, { 
          desc = 'Import selected symbol',
          silent = true 
        })
        
        -- Integration with telescope (if available)
        local has_telescope, telescope = pcall(require, 'telescope')
        if has_telescope then
          vim.keymap.set('n', '<leader>pT', function()
            telescope.extensions.python_import.python_import()
          end, { 
            desc = 'Telescope Python imports',
            silent = true 
          })
        end
        
        -- Commands for import management
        vim.api.nvim_create_user_command('PythonImportAuto', function()
          require('python-import').auto_import()
        end, { desc = 'Auto-import symbol under cursor' })
        
        vim.api.nvim_create_user_command('PythonImportOrganize', function()
          require('python-import').organize_imports()
        end, { desc = 'Organize all imports' })
        
        vim.api.nvim_create_user_command('PythonImportFind', function()
          require('python-import').find_imports()
        end, { desc = 'Find and insert imports' })
        
        vim.api.nvim_create_user_command('PythonImportRemoveUnused', function()
          require('python-import').remove_unused_imports()
        end, { desc = 'Remove unused imports' })
        
        vim.api.nvim_create_user_command('PythonImportRefresh', function()
          require('python-import').refresh_cache()
        end, { desc = 'Refresh import cache' })
        
        -- Auto-commands for intelligent import management
        vim.api.nvim_create_augroup("PythonImportAutoCommands", { clear = true })
        
        -- Auto-organize imports on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = "PythonImportAutoCommands",
          pattern = "*.py",
          callback = function()
            -- Only organize if file has imports
            local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
            for _, line in ipairs(lines) do
              if line:match("^import ") or line:match("^from ") then
                require('python-import').organize_imports()
                break
              end
            end
          end,
        })
        
        -- Show import suggestions for undefined symbols
        vim.api.nvim_create_autocmd("CursorHold", {
          group = "PythonImportAutoCommands",
          pattern = "*.py",
          callback = function()
            local word = vim.fn.expand('<cword>')
            if word and #word > 0 then
              -- Check if symbol is undefined (simple heuristic)
              local diagnostics = vim.diagnostic.get(0, { 
                lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 
              })
              
              for _, diag in ipairs(diagnostics) do
                if diag.message:match("is not defined") or diag.message:match("Undefined variable") then
                  vim.defer_fn(function()
                    require('python-import').suggest_import(word)
                  end, 100)
                  break
                end
              end
            end
          end,
        })
      '';
    };
  };
}