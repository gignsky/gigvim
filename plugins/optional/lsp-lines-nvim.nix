# lsp_lines.nvim Plugin Configuration
# Enhanced LSP diagnostic display with virtual lines
# Repository: https://git.sr.ht/~whynothugo/lsp_lines.nvim
#
# lsp_lines.nvim replaces the default LSP diagnostic virtual text
# with virtual lines that show diagnostics in a more readable format.
# This provides better visibility for long diagnostic messages.
#
# Features enabled:
# - Virtual lines for LSP diagnostics instead of inline virtual text
# - Better handling of long diagnostic messages  
# - Configurable display options
# - Toggle functionality for switching between modes
#
# Settings configured:
# - Enabled by default for better diagnostic visibility
# - Integrated with existing LSP configuration
# - Toggle keybinding to switch between virtual lines and virtual text
#
# Settings still need to be configured:
# - Custom diagnostic formatting options
# - Per-filetype diagnostic display preferences
# - Integration with other diagnostic plugins

{ inputs, pkgs, ... }:
let
  lsp-lines-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "lsp_lines-nvim";
    src = inputs.lsp-lines-nvim;
  };
in
{
  config.vim.extraPlugins = {
    lsp-lines = {
      package = lsp-lines-from-source;
      setup = ''
        -- Setup lsp_lines
        require('lsp_lines').setup()
        
        -- Disable virtual text since we're using virtual lines
        vim.diagnostic.config({
          virtual_text = false,  -- Disable default virtual text
          virtual_lines = true,  -- Enable virtual lines
        })
        
        -- Toggle function for switching between virtual lines and virtual text
        local function toggle_lsp_lines()
          local config = vim.diagnostic.config()
          if config.virtual_text then
            vim.diagnostic.config({
              virtual_text = false,
              virtual_lines = true,
            })
            vim.notify("LSP virtual lines enabled", vim.log.levels.INFO)
          else
            vim.diagnostic.config({
              virtual_text = true,
              virtual_lines = false,
            })
            vim.notify("LSP virtual text enabled", vim.log.levels.INFO)
          end
        end
        
        -- Key mapping for toggling diagnostic display mode
        vim.keymap.set('n', '<leader>dl', toggle_lsp_lines, { 
          desc = 'Toggle LSP virtual lines/text',
          silent = true 
        })
        
        -- Additional key mappings for diagnostic navigation
        vim.keymap.set('n', '<leader>dj', vim.diagnostic.goto_next, { 
          desc = 'Go to next diagnostic',
          silent = true 
        })
        vim.keymap.set('n', '<leader>dk', vim.diagnostic.goto_prev, { 
          desc = 'Go to previous diagnostic',
          silent = true 
        })
        vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { 
          desc = 'Open diagnostic float',
          silent = true 
        })
        vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { 
          desc = 'Set diagnostic loclist',
          silent = true 
        })
      '';
    };
  };
}