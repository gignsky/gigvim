{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add edge theme package
    edge = {
      package = pkgs.vimPlugins.edge;
    };
  };
}