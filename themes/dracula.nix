{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add dracula theme package
    dracula = {
      package = pkgs.vimPlugins.dracula-nvim;
    };
  };
}