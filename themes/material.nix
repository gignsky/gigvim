{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add material theme package
    material = {
      package = pkgs.vimPlugins.material-nvim;
    };
  };
}