{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add tender theme package
    tender = {
      package = pkgs.vimPlugins.tender-vim;
    };
  };
}