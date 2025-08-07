{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add tokyonight theme package
    tokyonight = {
      package = pkgs.vimPlugins.tokyonight-nvim;
    };
  };
}
