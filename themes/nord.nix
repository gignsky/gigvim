{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add nord theme package
    nord = {
      package = pkgs.vimPlugins.nord-nvim;
    };
  };
}
