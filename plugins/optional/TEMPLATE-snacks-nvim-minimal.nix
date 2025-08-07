# Snacks.nvim Minimal Configuration Template
# Essential snacks only - recommended for conservative setups
# Documentation: https://github.com/folke/snacks.nvim

{ inputs, pkgs, lib, ... }:
let
  snacks-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "snacks-nvim";
    src = inputs.snacks-nvim;
  };
in
{
  config.vim = {
    extraPlugins = {
      snacks-minimal = {
        package = snacks-from-source;
        setup = ''
          -- Minimal Snacks.nvim setup - only essential features
          require('snacks').setup({
            -- Essential snacks that provide significant value with minimal risk
            
            bigfile = { 
              enabled = true,
              size = 1.5 * 1024 * 1024, -- 1.5MB
            },
            
            input = { 
              enabled = true,
              -- Better vim.ui.input with nicer styling
            },
            
            notifier = {
              enabled = true,
              timeout = 3000,
              -- Clean notifications
            },
            
            quickfile = { 
              enabled = true,
              -- Fast file loading before plugins initialize
            },
            
            -- All other snacks disabled for minimal setup
            animate = { enabled = false },
            bufdelete = { enabled = false },
            dashboard = { enabled = false },
            debug = { enabled = false },
            dim = { enabled = false },
            explorer = { enabled = false },
            git = { enabled = false },
            gitbrowse = { enabled = false },
            image = { enabled = false },
            indent = { enabled = false },
            layout = { enabled = false },
            lazygit = { enabled = false },
            notify = { enabled = false },
            picker = { enabled = false },
            profiler = { enabled = false },
            rename = { enabled = false },
            scope = { enabled = false },
            scratch = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            terminal = { enabled = false },
            toggle = { enabled = false },
            util = { enabled = false },
            win = { enabled = false },
            words = { enabled = false },
            zen = { enabled = false },
            
            -- Minimal styles
            styles = {
              notification = {
                border = "rounded",
              },
              input = {
                border = "rounded",
              },
            },
          })
          
          -- Minimal keymaps - only for enabled features
          local opts = { noremap = true, silent = true }
          
          -- Notifications
          vim.keymap.set("n", "<leader>n", function() require("snacks").notifier.show_history() end, 
            vim.tbl_extend("force", opts, { desc = "Notification History" }))
          vim.keymap.set("n", "<leader>un", function() require("snacks").notifier.hide() end, 
            vim.tbl_extend("force", opts, { desc = "Dismiss Notifications" }))
        '';
      };
    };
  };
}