{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add sonokai theme package
    sonokai = {
      package = pkgs.vimPlugins.sonokai;
    };
  };
}