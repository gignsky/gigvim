# Snacks.nvim - A collection of small QoL plugins for Neovim
# https://github.com/folke/snacks.nvim

{ inputs, pkgs, ... }:
let
  snacks-nvim-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "snacks-nvim";
    src = inputs.snacks-nvim; # Must match the input name in flake.nix
  };
in
{
  config.vim.extraPlugins = {
    snacks-nvim = {
      package = snacks-nvim-from-source;
      setup = ''
        require('snacks').setup({
          -- Basic useful plugins enabled
          bigfile = { enabled = true },
          notifier = { 
            enabled = true,
            timeout = 3000,
          },
          quickfile = { enabled = true },
        })
      '';
    };
  };
}

