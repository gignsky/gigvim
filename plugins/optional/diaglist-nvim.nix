# diaglist.nvim Plugin Configuration
# Diagnostic list management for Neovim
# Repository: https://github.com/onsails/diaglist.nvim
#
# diaglist.nvim provides a clean interface for viewing and managing
# LSP diagnostics in a list format. It enhances the default diagnostic
# experience with better navigation and organization.
#
# Features enabled:
# - Diagnostic list window with improved formatting
# - Quick navigation between diagnostics
# - Filtering and sorting options for diagnostics
# - Integration with quickfix and location lists
# - Custom diagnostic icons and highlighting
#
# Settings configured:
# - Auto-open diagnostic list for critical errors
# - Custom keybindings for diagnostic list operations
# - Integration with telescope for enhanced searching
# - Diagnostic severity filtering
#
# Settings still need to be configured:
# - Per-project diagnostic filtering rules
# - Custom diagnostic grouping options
# - Integration with other diagnostic plugins

{ inputs, pkgs, ... }:
let
  diaglist-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "diaglist-nvim";
    src = inputs.diaglist-nvim;
  };
in
{
  config.vim.extraPlugins = {
    diaglist = {
      package = diaglist-from-source;
      setup = ''
        -- Setup diaglist
        require('diaglist').setup({
          -- Diagnostic list configuration
          debug = false,
          
          -- Automatically open diaglist for certain severities
          auto_open = true,
          
          -- Minimum severity to auto-open (1=ERROR, 2=WARN, 3=INFO, 4=HINT)
          auto_open_severity = vim.diagnostic.severity.ERROR,
          
          -- Auto close when all diagnostics are resolved
          auto_close = true,
          
          -- Show diagnostic source (LSP server name)
          show_source = true,
          
          -- Diagnostic icons (using devicons)
          icons = {
            error = "󰅙",
            warn = "",
            info = "󰋼",
            hint = "󰌵",
          },
          
          -- Highlight groups for different severities
          highlight_groups = {
            error = "DiagnosticSignError",
            warn = "DiagnosticSignWarn", 
            info = "DiagnosticSignInfo",
            hint = "DiagnosticSignHint",
          },
          
          -- Window configuration
          window = {
            type = "float",  -- "float" or "split"
            relative = "editor",
            position = "bottom",
            size = {
              width = 0.8,
              height = 0.3,
            },
            border = "rounded",
            title = " Diagnostics ",
            title_pos = "center",
          },
          
          -- List configuration
          list = {
            format = function(diagnostic)
              local severity_map = {
                [vim.diagnostic.severity.ERROR] = "ERROR",
                [vim.diagnostic.severity.WARN] = "WARN",
                [vim.diagnostic.severity.INFO] = "INFO", 
                [vim.diagnostic.severity.HINT] = "HINT",
              }
              
              local filename = vim.fn.fnamemodify(diagnostic.filename, ":t")
              local severity = severity_map[diagnostic.severity] or "UNKNOWN"
              
              return string.format(
                "%s:%d:%d [%s] %s",
                filename,
                diagnostic.lnum + 1,
                diagnostic.col + 1,
                severity,
                diagnostic.message:gsub("\n", " ")
              )
            end,
            
            -- Sort diagnostics by severity then by filename
            sort = function(a, b)
              if a.severity ~= b.severity then
                return a.severity < b.severity
              end
              return a.filename < b.filename
            end,
          },
        })
        
        -- Key mappings for diaglist operations
        vim.keymap.set('n', '<leader>dd', '<cmd>lua require("diaglist").toggle()<cr>', { 
          desc = 'Toggle diagnostic list',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>dD', '<cmd>lua require("diaglist").open_all()<cr>', { 
          desc = 'Open all diagnostics',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>dc', '<cmd>lua require("diaglist").close()<cr>', { 
          desc = 'Close diagnostic list',
          silent = true 
        })
        
        -- Filter diagnostics by severity
        vim.keymap.set('n', '<leader>de', function()
          require("diaglist").open({ severity = vim.diagnostic.severity.ERROR })
        end, { 
          desc = 'Show only errors',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>dw', function()
          require("diaglist").open({ 
            severity = { 
              vim.diagnostic.severity.ERROR, 
              vim.diagnostic.severity.WARN 
            } 
          })
        end, { 
          desc = 'Show errors and warnings',
          silent = true 
        })
        
        -- Integration with telescope (if available)
        local has_telescope, telescope = pcall(require, 'telescope')
        if has_telescope then
          vim.keymap.set('n', '<leader>dt', function()
            telescope.extensions.diaglist.diaglist()
          end, { 
            desc = 'Telescope diagnostic list',
            silent = true 
          })
        end
        
        -- Auto-commands for diagnostic management
        vim.api.nvim_create_augroup("DiaglistAutoCommands", { clear = true })
        
        -- Auto-open diaglist when there are new errors
        vim.api.nvim_create_autocmd("DiagnosticChanged", {
          group = "DiaglistAutoCommands",
          callback = function()
            local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            if #diagnostics > 0 then
              require("diaglist").open({ severity = vim.diagnostic.severity.ERROR })
            end
          end,
        })
      '';
    };
  };
}