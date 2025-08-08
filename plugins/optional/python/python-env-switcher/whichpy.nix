# whichpy.nvim Plugin Configuration
# Automatic Python environment detection and switching
# Repository: https://github.com/neolooong/whichpy.nvim
#
# whichpy.nvim automatically detects and switches Python environments
# based on project structure and configuration files. It integrates
# with various Python tools and virtual environment managers.
#
# Features enabled:
# - Automatic Python environment detection
# - Support for virtualenv, conda, pyenv, poetry, pipenv
# - Integration with LSP for environment-aware language server
# - Project-based environment switching
# - Status line integration for current environment display
#
# Detection methods:
# - pyproject.toml (Poetry projects)
# - Pipfile (Pipenv projects)
# - requirements.txt with .venv directory
# - conda environment files
# - pyenv version files
#
# Settings configured:
# - Auto-detection on project open
# - LSP restart on environment change
# - Environment display in status line
# - Integration with common Python project structures
#
# Settings still need to be configured:
# - Custom environment detection rules
# - Per-project environment preferences
# - Integration with remote development

{ inputs, pkgs, ... }:
let
  whichpy-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "whichpy-nvim";
    src = inputs.whichpy-nvim;
  };
in
{
  config.vim.extraPlugins = {
    whichpy = {
      package = whichpy-from-source;
      setup = ''
        require('whichpy').setup({
          -- Auto-detection configuration
          auto_detect = {
            enabled = true,
            patterns = {
              -- Project root indicators
              "pyproject.toml",    -- Poetry
              "Pipfile",           -- Pipenv  
              "requirements.txt",  -- pip
              "setup.py",          -- setuptools
              "setup.cfg",         -- setuptools
              "environment.yml",   -- conda
              ".python-version",   -- pyenv
              ".venv/",            -- virtualenv
              "venv/",             -- virtualenv
              "env/",              -- virtualenv
            },
            
            -- Auto-switch when entering Python files
            on_buf_enter = true,
            
            -- Auto-switch when opening project
            on_vim_enter = true,
          },
          
          -- Environment detection order (higher priority first)
          detection_order = {
            "poetry",      -- Poetry environments
            "pipenv",      -- Pipenv environments
            "conda",       -- Conda environments
            "pyenv",       -- Pyenv environments
            "virtualenv",  -- Standard virtualenv
            "system",      -- System Python (fallback)
          },
          
          -- Python executable detection
          python_executable = {
            -- Prefer python3 over python
            names = { "python3", "python" },
            
            -- Validate Python executable
            validate = true,
            
            -- Minimum Python version
            min_version = "3.7",
          },
          
          -- LSP integration
          lsp = {
            -- Restart LSP when environment changes
            auto_restart = true,
            
            -- LSP servers to restart
            servers = { "pyright", "pylsp", "jedi_language_server" },
            
            -- Update LSP configuration with new Python path
            update_config = true,
          },
          
          -- Status line integration
          statusline = {
            enabled = true,
            format = "🐍 %s",  -- Format string for environment name
            
            -- Show only environment name (not full path)
            short_name = true,
          },
          
          -- Logging configuration
          log = {
            level = "info",  -- "debug", "info", "warn", "error"
            file = vim.fn.stdpath("data") .. "/whichpy.log",
          },
          
          -- Notification settings
          notify = {
            -- Show notifications on environment change
            on_change = true,
            
            -- Notification timeout (ms)
            timeout = 3000,
            
            -- Show environment details
            show_details = true,
          },
        })
        
        -- Key mappings for manual environment management
        vim.keymap.set('n', '<leader>pe', function()
          require('whichpy').show_current()
        end, { 
          desc = 'Show current Python environment',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>ps', function()
          require('whichpy').select_environment()
        end, { 
          desc = 'Select Python environment',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>pr', function()
          require('whichpy').refresh()
        end, { 
          desc = 'Refresh Python environment detection',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>pt', function()
          require('whichpy').toggle_auto_detect()
        end, { 
          desc = 'Toggle auto-detection',
          silent = true 
        })
        
        -- Commands for environment management
        vim.api.nvim_create_user_command('WhichPyShow', function()
          require('whichpy').show_current()
        end, { desc = 'Show current Python environment' })
        
        vim.api.nvim_create_user_command('WhichPySelect', function()
          require('whichpy').select_environment()
        end, { desc = 'Select Python environment' })
        
        vim.api.nvim_create_user_command('WhichPyRefresh', function()
          require('whichpy').refresh()
        end, { desc = 'Refresh environment detection' })
        
        vim.api.nvim_create_user_command('WhichPyToggle', function()
          require('whichpy').toggle_auto_detect()
        end, { desc = 'Toggle auto-detection' })
        
        -- Auto-commands for enhanced Python workflow
        vim.api.nvim_create_augroup("WhichPyAutoCommands", { clear = true })
        
        -- Show environment info when opening Python files
        vim.api.nvim_create_autocmd("FileType", {
          group = "WhichPyAutoCommands",
          pattern = "python",
          callback = function()
            -- Delay to let environment detection complete
            vim.defer_fn(function()
              local env = require('whichpy').get_current()
              if env then
                vim.notify(string.format("Python environment: %s", env.name), vim.log.levels.INFO)
              end
            end, 500)
          end,
        })
        
        -- Refresh environment when Python project files change
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          group = "WhichPyAutoCommands",
          pattern = { "pyproject.toml", "Pipfile", "requirements.txt", ".python-version", "environment.yml" },
          callback = function()
            require('whichpy').refresh()
          end,
        })
      '';
    };
  };
}