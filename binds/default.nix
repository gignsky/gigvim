{
  config.vim.keymaps = [
    {
      key = "jj";
      mode = "i";
      silent = true;
      action = "<Esc>";
    }
    {
      key = ";";
      mode = "i";
      silent = true;
      action = ";<Esc>i";
    }
  ];
}
