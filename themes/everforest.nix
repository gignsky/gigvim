{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add everforest theme package
    everforest = {
      package = pkgs.vimPlugins.everforest;
    };
  };
}