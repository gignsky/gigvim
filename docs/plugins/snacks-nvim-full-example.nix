# Example: Integrating snacks.nvim into full.nix
# This example shows how to add snacks.nvim to the full GigVim configuration

{ inputs, pkgs, ... }:
let
  # Import the themery module with inputs passed through
  themeryModule = import ./plugins/optional/themery-nvim.nix { inherit inputs pkgs; };
  
  # Import snacks.nvim module with inputs passed through
  snacksModule = import ./plugins/optional/snacks-nvim.nix { inherit inputs pkgs; };
in
{
  imports = [
    ./minimal.nix
    themeryModule
    snacksModule  # Add snacks.nvim to the full configuration
  ];
  
  # Optional: Override specific snacks.nvim settings
  config.vim.extraPlugins.snacks.setup = ''
    -- Override or extend the default snacks configuration
    local default_config = require('snacks').setup({
      -- Your custom snacks configuration here
      -- This will override settings from snacks-nvim.nix
      
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
        preset = {
          header = [[
 ██████╗ ██╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
██╔════╝ ██║██╔════╝ ██║   ██║██║████╗ ████║
██║  ███╗██║██║  ███╗██║   ██║██║██╔████╔██║
██║   ██║██║██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
╚██████╔╝██║╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═════╝ ╚═╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      
      -- Enable additional snacks for full configuration
      git = { enabled = true },
      gitbrowse = { enabled = true },
      lazygit = { 
        enabled = true,
        configure = true,
      },
      terminal = { enabled = true },
      scratch = { enabled = true },
      zen = { enabled = true },
      
      -- Customize notification settings for full config
      notifier = {
        enabled = true,
        timeout = 4000,
        width = { min = 40, max = 0.5 },
        height = { min = 1, max = 0.7 },
        margin = { top = 0, right = 1, bottom = 0 },
        sort = { "level", "added" },
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          debug = " ",
          trace = " ",
        },
      },
    })
    
    -- Add additional keymaps for full configuration
    local opts = { noremap = true, silent = true }
    local snacks = require("snacks")
    
    -- Additional git keymaps
    vim.keymap.set("n", "<leader>gg", function() snacks.lazygit() end, 
      vim.tbl_extend("force", opts, { desc = "LazyGit" }))
    vim.keymap.set("n", "<leader>gB", function() snacks.gitbrowse() end, 
      vim.tbl_extend("force", opts, { desc = "Git Browse" }))
    vim.keymap.set("v", "<leader>gB", function() snacks.gitbrowse() end, 
      vim.tbl_extend("force", opts, { desc = "Git Browse" }))
      
    -- Terminal keymaps
    vim.keymap.set("n", "<c-/>", function() snacks.terminal() end, 
      vim.tbl_extend("force", opts, { desc = "Toggle Terminal" }))
    vim.keymap.set("n", "<c-_>", function() snacks.terminal() end, 
      vim.tbl_extend("force", opts, { desc = "which_key_ignore" }))
      
    -- Zen mode keymaps
    vim.keymap.set("n", "<leader>z", function() snacks.zen() end, 
      vim.tbl_extend("force", opts, { desc = "Toggle Zen Mode" }))
    vim.keymap.set("n", "<leader>Z", function() snacks.zen.zoom() end, 
      vim.tbl_extend("force", opts, { desc = "Toggle Zoom" }))
      
    -- Scratch buffer keymaps
    vim.keymap.set("n", "<leader>.", function() snacks.scratch() end, 
      vim.tbl_extend("force", opts, { desc = "Toggle Scratch Buffer" }))
    vim.keymap.set("n", "<leader>S", function() snacks.scratch.select() end, 
      vim.tbl_extend("force", opts, { desc = "Select Scratch Buffer" }))
  '';
}