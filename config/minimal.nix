{
  imports = [
    ./core
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
}
