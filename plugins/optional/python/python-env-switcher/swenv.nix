# swenv.nvim Plugin Configuration  
# Simple Python virtual environment switcher
# Repository: https://github.com/AckslD/swenv.nvim
#
# swenv.nvim provides a simple interface for manually switching between
# Python virtual environments. It offers more control than automatic
# detection and integrates well with telescope for environment selection.
#
# Features enabled:
# - Manual Python environment switching via picker
# - Integration with telescope for environment selection
# - Support for virtualenv, conda, pyenv environments
# - LSP restart on environment change
# - Status line display of current environment
#
# Environment detection:
# - Scans common virtual environment directories
# - Supports conda environments
# - Integrates with pyenv for version management
# - Custom environment path configuration
#
# Settings configured:
# - Telescope integration for environment picker
# - Auto-LSP restart on environment change
# - Environment validation before switching
# - Status line integration for current environment
#
# Settings still need to be configured:
# - Custom environment search paths
# - Per-project environment preferences
# - Integration with external environment managers

{ inputs, pkgs, ... }:
let
  swenv-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "swenv-nvim";
    src = inputs.swenv-nvim;
  };
in
{
  config.vim.extraPlugins = {
    swenv = {
      package = swenv-from-source;
      setup = ''
        require('swenv').setup({
          -- Virtual environment search paths
          venvs_path = {
            vim.fn.expand('~/.virtualenvs'),  -- virtualenvwrapper default
            vim.fn.expand('~/.conda/envs'),   -- conda environments
            vim.fn.expand('~/.pyenv/versions'), -- pyenv versions
            vim.fn.expand('./venv'),          -- project local venv
            vim.fn.expand('./.venv'),         -- project local .venv
            vim.fn.expand('./env'),           -- project local env
          },
          
          -- Environment picker configuration
          picker = {
            -- Use telescope for environment selection
            telescope = {
              enabled = true,
              layout_strategy = "horizontal",
              layout_config = {
                height = 0.4,
                width = 0.8,
              },
            },
            
            -- Fallback to vim.ui.select if telescope not available
            fallback = "vim.ui.select",
          },
          
          -- LSP integration
          lsp = {
            -- Automatically restart LSP servers on environment change
            auto_restart = true,
            
            -- Which LSP servers to restart
            servers = { "pyright", "pylsp", "jedi_language_server" },
          },
          
          -- Validation before switching environments
          validation = {
            -- Check if Python executable exists
            check_executable = true,
            
            -- Check if environment is valid Python installation
            check_installation = true,
            
            -- Minimum Python version
            min_version = "3.7",
          },
          
          -- Status line integration
          statusline = {
            enabled = true,
            
            -- Format for status line display
            format = function(env_name)
              return string.format("🐍 %s", env_name or "system")
            end,
            
            -- Show short name instead of full path
            short_name = true,
          },
          
          -- Post-switch hooks
          post_set_venv = function(venv_path, venv_name)
            -- Update environment variables
            vim.env.VIRTUAL_ENV = venv_path
            vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
            
            -- Notify about environment change
            vim.notify(
              string.format("Switched to Python environment: %s", venv_name),
              vim.log.levels.INFO,
              { title = "Python Environment" }
            )
            
            -- Update LSP configuration if pyright is available
            local clients = vim.lsp.get_active_clients({ name = "pyright" })
            for _, client in ipairs(clients) do
              if client.config.settings then
                client.config.settings.python = client.config.settings.python or {}
                client.config.settings.python.pythonPath = venv_path .. "/bin/python"
              end
            end
          end,
          
          -- Pre-switch hooks
          pre_set_venv = function(venv_path, venv_name)
            -- Validate environment before switching
            local python_exe = venv_path .. "/bin/python"
            if vim.fn.executable(python_exe) == 0 then
              vim.notify(
                string.format("Python executable not found: %s", python_exe),
                vim.log.levels.ERROR
              )
              return false  -- Cancel switch
            end
            return true  -- Allow switch
          end,
        })
        
        -- Key mappings for environment management
        vim.keymap.set('n', '<leader>pv', function()
          require('swenv.api').pick_venv()
        end, { 
          desc = 'Pick Python virtual environment',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>pc', function()
          local venv = require('swenv.api').get_current_venv()
          if venv then
            vim.notify(string.format("Current environment: %s", venv.name), vim.log.levels.INFO)
          else
            vim.notify("No virtual environment active", vim.log.levels.WARN)
          end
        end, { 
          desc = 'Show current Python environment',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>pd', function()
          require('swenv.api').set_venv(nil)
          vim.notify("Deactivated Python virtual environment", vim.log.levels.INFO)
        end, { 
          desc = 'Deactivate Python environment',
          silent = true 
        })
        
        -- Integration with telescope (if available)
        local has_telescope, telescope = pcall(require, 'telescope')
        if has_telescope then
          telescope.load_extension('swenv')
          
          vim.keymap.set('n', '<leader>pT', function()
            telescope.extensions.swenv.swenv()
          end, { 
            desc = 'Telescope Python environments',
            silent = true 
          })
        end
        
        -- Commands for environment management
        vim.api.nvim_create_user_command('SwenvPick', function()
          require('swenv.api').pick_venv()
        end, { desc = 'Pick Python virtual environment' })
        
        vim.api.nvim_create_user_command('SwenvCurrent', function()
          local venv = require('swenv.api').get_current_venv()
          if venv then
            print(string.format("Current environment: %s (%s)", venv.name, venv.path))
          else
            print("No virtual environment active")
          end
        end, { desc = 'Show current environment' })
        
        vim.api.nvim_create_user_command('SwenvDeactivate', function()
          require('swenv.api').set_venv(nil)
        end, { desc = 'Deactivate virtual environment' })
        
        vim.api.nvim_create_user_command('SwenvList', function()
          local venvs = require('swenv.api').get_venvs()
          if #venvs == 0 then
            print("No virtual environments found")
            return
          end
          
          print("Available Python environments:")
          for i, venv in ipairs(venvs) do
            print(string.format("  %d. %s (%s)", i, venv.name, venv.path))
          end
        end, { desc = 'List available environments' })
        
        -- Auto-commands for enhanced workflow
        vim.api.nvim_create_augroup("SwenvAutoCommands", { clear = true })
        
        -- Show available environments when entering Python files
        vim.api.nvim_create_autocmd("FileType", {
          group = "SwenvAutoCommands",
          pattern = "python",
          once = true,  -- Only show once per session
          callback = function()
            local venvs = require('swenv.api').get_venvs()
            if #venvs > 0 then
              vim.notify(
                string.format("Found %d Python environment(s). Use <leader>pv to switch.", #venvs),
                vim.log.levels.INFO,
                { title = "Python Environments" }
              )
            else
              vim.notify(
                "No Python virtual environments found",
                vim.log.levels.WARN,
                { title = "Python Environments" }
              )
            end
          end,
        })
      '';
    };
  };
}