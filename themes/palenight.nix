{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add palenight theme package
    palenight = {
      package = pkgs.vimPlugins.palenight-vim;
    };
  };
}