# Otter Configuration for Embedded Language Support
# Provides keybindings and utilities for otter-nvim functionality

{ pkgs, ... }:
{
  config.vim = {
    # Enable otter-nvim for embedded language support
    lsp.otter-nvim.enable = true;
    
    # Otter-specific Lua configuration
    luaConfigRC.otter-config = ''
      -- Note: otter-nvim is enabled above
      
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