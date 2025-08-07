{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add solarized theme package
    solarized = {
      package = pkgs.vimPlugins.solarized-nvim;
    };
  };
}