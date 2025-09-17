{
  config.vim.keymaps = [
    {
      key = "zf";
      mode = "n";
      action = "<cmd>fold<cr>";
      silent = true;
      desc = "Create fold";
    }
    {
      key = "zo";
      mode = "n";
      action = "<cmd>foldopen<cr>";
      silent = true;
      desc = "Open fold";
    }
    {
      key = "zc";
      mode = "n";
      action = "<cmd>foldclose<cr>";
      silent = true;
      desc = "Close fold";
    }
    {
      key = "za";
      mode = "n";
      action = "<cmd>foldopen<cr>";
      silent = true;
      desc = "Toggle fold";
    }
    {
      key = "zR";
      mode = "n";
      action = "<cmd>normal! zR<cr>";
      silent = true;
      desc = "Open all folds";
    }
    {
      key = "zM";
      mode = "n";
      action = "<cmd>normal! zM<cr>";
      silent = true;
      desc = "Close all folds";
    }
    {
      key = "<leader>zf";
      mode = "n";
      action = "<cmd>FoldCreate<cr>";
      silent = true;
      desc = "Create fold with range";
    }
    {
      key = "<leader>zo";
      mode = "n";
      action = "<cmd>FoldOpen<cr>";
      silent = true;
      desc = "Open fold at cursor";
    }
  ];
}