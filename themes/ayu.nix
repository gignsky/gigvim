{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add ayu theme package
    ayu = {
      package = pkgs.vimPlugins.ayu-vim;
    };
  };
}