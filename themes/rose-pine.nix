{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add rose-pine theme package
    rose-pine = {
      package = pkgs.vimPlugins.rose-pine;
    };
  };
}