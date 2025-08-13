# workspace-diagnostics.nvim Plugin Configuration
# Workspace-wide diagnostic collection and management
# Repository: https://github.com/artemave/workspace-diagnostics.nvim
#
# workspace-diagnostics.nvim extends Neovim's diagnostic capabilities
# to work across the entire workspace, not just open buffers.
# It provides a comprehensive view of all issues in your project.
#
# Features enabled:
# - Workspace-wide diagnostic collection
# - Background diagnostic scanning of project files
# - Integration with existing LSP diagnostics
# - Persistent diagnostic caching
# - Project-wide error and warning overview
#
# Settings configured:
# - Auto-scanning on project load
# - Integration with telescope for workspace diagnostic search
# - Background scanning without blocking UI
# - Configurable file patterns for scanning
#
# Settings still need to be configured:
# - Custom file exclusion patterns
# - Diagnostic severity filtering per project
# - Integration with CI/CD workflows
# - Custom diagnostic sources beyond LSP

{ inputs, pkgs, ... }:
let
  workspace-diagnostics-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "workspace-diagnostics-nvim";
    src = inputs.workspace-diagnostics-nvim;
  };
in
{
  config.vim.extraPlugins = {
    workspace-diagnostics = {
      package = workspace-diagnostics-from-source;
      setup = ''
        require('workspace-diagnostics').setup({
          -- Workspace scanning configuration
          workspace_files = {
            -- File patterns to include in workspace scanning
            patterns = { "**/*.rs", "**/*.nix", "**/*.py", "**/*.js", "**/*.ts", "**/*.lua", "**/*.sh", "**/*.nu" },
            
            -- File patterns to exclude from scanning
            ignore_patterns = {
              "**/node_modules/**",
              "**/target/**",
              "**/.git/**",
              "**/result/**",
              "**/*.lock",
              "**/dist/**",
              "**/build/**",
              "**/__pycache__/**",
              "**/*.pyc",
            },
            
            -- Maximum number of files to scan
            max_files = 1000,
          },
          
          -- Diagnostic collection settings
          diagnostics = {
            -- Automatically collect diagnostics on workspace open
            auto_collect = true,
            
            -- Collect diagnostics in background without blocking
            async = true,
            
            -- Update interval for background collection (ms)
            update_interval = 5000,
            
            -- Minimum severity to collect (1=ERROR, 2=WARN, 3=INFO, 4=HINT)
            min_severity = vim.diagnostic.severity.WARN,
            
            -- Maximum diagnostics per file to avoid performance issues
            max_per_file = 100,
          },
          
          -- Cache configuration for persistent diagnostics
          cache = {
            -- Enable persistent caching across sessions
            enabled = true,
            
            -- Cache directory (relative to project root)
            dir = ".nvim-workspace-diagnostics",
            
            -- Cache expiry time in seconds (24 hours)
            expiry = 86400,
          },
          
          -- UI configuration
          ui = {
            -- Show progress notifications during scanning
            show_progress = true,
            
            -- Show diagnostic counts in statusline (requires integration)
            statusline = false,  -- Disabled as we use heirline
            
            -- Highlight groups for different severities
            highlight_groups = {
              error = "DiagnosticSignError",
              warn = "DiagnosticSignWarn",
              info = "DiagnosticSignInfo", 
              hint = "DiagnosticSignHint",
            },
          },
          
          -- Integration with other plugins
          integrations = {
            -- Enable telescope integration
            telescope = true,
            
            -- Enable quickfix integration
            quickfix = true,
            
            -- Enable location list integration
            loclist = true,
          },
        })
        
        -- Key mappings for workspace diagnostics
        vim.keymap.set('n', '<leader>wr', function()
          require('workspace-diagnostics').refresh()
        end, { 
          desc = 'Refresh workspace diagnostics',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>ws', function()
          require('workspace-diagnostics').scan()
        end, { 
          desc = 'Scan workspace for diagnostics',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>wc', function()
          require('workspace-diagnostics').clear()
        end, { 
          desc = 'Clear workspace diagnostics cache',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>wt', function()
          require('workspace-diagnostics').toggle()
        end, { 
          desc = 'Toggle workspace diagnostics',
          silent = true 
        })
        
        -- Show workspace diagnostic summary
        vim.keymap.set('n', '<leader>wi', function()
          local diagnostics = require('workspace-diagnostics').get_all()
          local errors = 0
          local warnings = 0
          local info = 0
          local hints = 0
          
          for _, diag in ipairs(diagnostics) do
            if diag.severity == vim.diagnostic.severity.ERROR then
              errors = errors + 1
            elseif diag.severity == vim.diagnostic.severity.WARN then
              warnings = warnings + 1
            elseif diag.severity == vim.diagnostic.severity.INFO then
              info = info + 1
            elseif diag.severity == vim.diagnostic.severity.HINT then
              hints = hints + 1
            end
          end
          
          local message = string.format(
            "Workspace Diagnostics Summary:\\nErrors: %d\\nWarnings: %d\\nInfo: %d\\nHints: %d\\nTotal: %d",
            errors, warnings, info, hints, #diagnostics
          )
          
          vim.notify(message, vim.log.levels.INFO, { title = "Workspace Diagnostics" })
        end, { 
          desc = 'Show workspace diagnostics summary',
          silent = true 
        })
        
        -- Integration with telescope (if available)
        local has_telescope, telescope = pcall(require, 'telescope')
        if has_telescope then
          vim.keymap.set('n', '<leader>wd', function()
            telescope.extensions.workspace_diagnostics.workspace_diagnostics()
          end, { 
            desc = 'Telescope workspace diagnostics',
            silent = true 
          })
          
          -- Filter workspace diagnostics by severity
          vim.keymap.set('n', '<leader>wde', function()
            telescope.extensions.workspace_diagnostics.workspace_diagnostics({
              severity = vim.diagnostic.severity.ERROR
            })
          end, { 
            desc = 'Telescope workspace errors',
            silent = true 
          })
          
          vim.keymap.set('n', '<leader>wdw', function()
            telescope.extensions.workspace_diagnostics.workspace_diagnostics({
              severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN }
            })
          end, { 
            desc = 'Telescope workspace errors & warnings',
            silent = true 
          })
        end
        
        -- Auto-commands for workspace diagnostic management
        vim.api.nvim_create_augroup("WorkspaceDiagnosticsAutoCommands", { clear = true })
        
        -- Auto-scan workspace when entering a new project
        vim.api.nvim_create_autocmd("VimEnter", {
          group = "WorkspaceDiagnosticsAutoCommands",
          callback = function()
            -- Delay to let LSP servers start up
            vim.defer_fn(function()
              if vim.fn.isdirectory('.git') == 1 or vim.fn.filereadable('Cargo.toml') == 1 or vim.fn.filereadable('flake.nix') == 1 then
                require('workspace-diagnostics').scan()
              end
            end, 3000)
          end,
        })
        
        -- Auto-refresh diagnostics when files change
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          group = "WorkspaceDiagnosticsAutoCommands",
          callback = function()
            -- Debounce the refresh to avoid too frequent updates
            local timer = vim.loop.new_timer()
            timer:start(1000, 0, vim.schedule_wrap(function()
              require('workspace-diagnostics').refresh_file(vim.api.nvim_buf_get_name(0))
              timer:close()
            end))
          end,
        })
        
        -- Commands for manual control
        vim.api.nvim_create_user_command('WorkspaceDiagnosticsRefresh', function()
          require('workspace-diagnostics').refresh()
        end, { desc = 'Refresh workspace diagnostics' })
        
        vim.api.nvim_create_user_command('WorkspaceDiagnosticsScan', function()
          require('workspace-diagnostics').scan()
        end, { desc = 'Scan workspace for diagnostics' })
        
        vim.api.nvim_create_user_command('WorkspaceDiagnosticsClear', function()
          require('workspace-diagnostics').clear()
        end, { desc = 'Clear workspace diagnostics cache' })
      '';
    };
  };
}