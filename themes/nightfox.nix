{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    # Add nightfox theme package (includes nightfox, duskfox, nordfox, terafox, carbonfox)
    nightfox = {
      package = pkgs.vimPlugins.nightfox-nvim;
    };
  };
}