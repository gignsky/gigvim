{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add onelight theme package
    onelight = {
      package = pkgs.vimPlugins.onedark-nvim;
    };
  };
}