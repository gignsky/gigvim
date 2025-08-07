{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add gruvbox theme package
    gruvbox = {
      package = pkgs.vimPlugins.gruvbox-nvim;
    };
  };
}
