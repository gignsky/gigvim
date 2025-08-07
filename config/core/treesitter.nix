# TreeSitter configuration
# Extracted from lang/default.nix to make it configurable
{ pkgs, ... }:
{
  config.vim.treesitter = {
    enable = true;
    addDefaultGrammars = true;
    autotagHtml = true;
    grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
  };
}