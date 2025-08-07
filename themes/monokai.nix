{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add monokai theme package
    monokai = {
      package = pkgs.vimPlugins.monokai-nvim;
    };
  };
}