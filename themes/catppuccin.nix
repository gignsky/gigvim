{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add catpuccin theme packages
    catppuccin = {
      package = pkgs.vimPlugins.catppuccin-nvim;
    };
  };
}
