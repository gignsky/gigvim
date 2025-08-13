# Snacks.nvim - A collection of small QoL plugins for Neovim
# https://github.com/folke/snacks.nvim

{ inputs, pkgs, ... }:
let
  snacks-nvim-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "snacks-nvim";
    src = inputs.snacks-nvim; # Must match the input name in flake.nix
    doCheck = false; # Disable require check due to optional dependencies
  };
in
{
  config.vim.extraPlugins = {
    snacks-nvim = {
      package = snacks-nvim-from-source;
      setup = ''
        require('snacks').setup({
          -- Core performance and usability plugins
          bigfile = { enabled = true },
          quickfile = { enabled = true },
          
          -- Enhanced notification system with LSP progress
          notifier = { 
            enabled = true,
            timeout = 3000,
            style = "fancy",
            top_down = false,
          },
          
          -- Git integration (prioritized as requested)
          lazygit = { 
            enabled = true,
            configure = true,
          },
          git = { enabled = true },
          gitbrowse = { enabled = true },
          
          -- UI enhancements
          dashboard = { enabled = true },
          indent = { enabled = true },
          dim = { enabled = true },
          animate = { enabled = true },
          
          -- Development tools
          bufdelete = { enabled = true },
          explorer = { enabled = true },
          input = { enabled = true },
          picker = { enabled = true },
          
          -- Additional utilities
          debug = { enabled = true },
          health = { enabled = true },
          layout = { enabled = true },
          profiler = { enabled = true },
          
          -- Terminal and image support
          terminal = { enabled = true },
          image = { enabled = true },
        })
      '';
    };
  };
}

