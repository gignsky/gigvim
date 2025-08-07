{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add onedark theme package
    onedark = {
      package = pkgs.vimPlugins.onedark-nvim;
    };
  };
}