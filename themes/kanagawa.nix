{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add kanagawa theme package
    kanagawa = {
      package = pkgs.vimPlugins.kanagawa-nvim;
    };
  };
}