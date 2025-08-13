{ pkgs, ... }:
{
  imports = [
    ./core
    ./embedded-languages.nix
  ];

  config.vim.clipboard.registers = "unnamedplus";

  config.vim.binds = {
    cheatsheet.enable = true;
    whichKey.enable = true;
  };

  config.vim.globals = {
    mapleader = " ";
    maplocalleader = " ";
    have_nerd_font = true;
  };

  config.vim.extraPackages = with pkgs; [
    nil
    alejandra
    tree-sitter
  ];
}
