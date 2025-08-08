# nvim-bacon Plugin Configuration
# Rust testing and compilation feedback plugin for Neovim
# Repository: https://github.com/Canop/nvim-bacon
#
# nvim-bacon provides real-time rust compilation feedback in Neovim.
# It's designed to be lightweight and fast, integrating with cargo check/test.
# 
# Features enabled:
# - Automatic compilation checking with cargo check
# - Real-time error and warning display
# - Integration with Neovim's quickfix window
# - Support for cargo test execution
# - Configurable keybindings for bacon commands
#
# Settings configured:
# - Auto-start bacon on Rust file open
# - Error display in quickfix
# - Default to cargo check mode
#
# Settings still need to be configured:
# - Custom keybindings (currently using defaults)
# - Project-specific bacon configurations
# - Integration with other Rust tools
# - Custom bacon.toml configurations

{ inputs, pkgs, ... }:
let
  nvim-bacon-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-bacon";
    src = inputs.nvim-bacon;
  };
in
{
  config.vim.extraPlugins = {
    nvim-bacon = {
      package = nvim-bacon-from-source;
      setup = ''
        require('bacon').setup({
          -- Auto-start bacon when opening Rust files
          autostart = true,
          
          -- Show bacon results in quickfix window
          quickfix = {
            enabled = true,
            event_trigger = true,
          },
          
          -- Default bacon command (cargo check)
          command = "check",
          
          -- Bacon executable path (will use system bacon if available)
          bacon_path = "${pkgs.bacon}/bin/bacon",
        })
        
        -- Key mappings for bacon commands
        vim.keymap.set('n', '<leader>bc', '<cmd>BaconLoad<cr><cmd>w<cr><cmd>BaconNext<cr>', { desc = 'Bacon Check' })
        vim.keymap.set('n', '<leader>bt', '<cmd>BaconLoad<cr><cmd>w<cr><cmd>BaconTest<cr>', { desc = 'Bacon Test' })
        vim.keymap.set('n', '<leader>bl', '<cmd>BaconList<cr>', { desc = 'Bacon List' })
        vim.keymap.set('n', '<leader>bn', '<cmd>BaconNext<cr>', { desc = 'Bacon Next' })
        vim.keymap.set('n', '<leader>bp', '<cmd>BaconPrevious<cr>', { desc = 'Bacon Previous' })
      '';
    };
  };

  # Ensure bacon binary is available
  config.vim.extraPackages = with pkgs; [
    bacon
  ];
}