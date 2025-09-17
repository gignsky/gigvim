{
  config.vim.keymaps = [
    # Folding heading for which-key
    {
      key = "<leader>z";
      mode = "n";
      action = "";
      silent = true;
      desc = "+Folding";
    }
    # Leader-based folding keybindings for better which-key integration
    {
      key = "<leader>zf";
      mode = "n";
      action = "zf";
      silent = true;
      desc = "Create fold";
    }
    {
      key = "<leader>zo";
      mode = "n";
      action = "zo";
      silent = true;
      desc = "Open fold";
    }
    {
      key = "<leader>zc";
      mode = "n";
      action = "zc";
      silent = true;
      desc = "Close fold";
    }
    {
      key = "<leader>za";
      mode = "n";
      action = "za";
      silent = true;
      desc = "Toggle fold";
    }
    {
      key = "<leader>zR";
      mode = "n";
      action = "zR";
      silent = true;
      desc = "Open all folds";
    }
    {
      key = "<leader>zM";
      mode = "n";
      action = "zM";
      silent = true;
      desc = "Close all folds";
    }
    {
      key = "<leader>zd";
      mode = "n";
      action = "zd";
      silent = true;
      desc = "Delete fold";
    }
    {
      key = "<leader>zE";
      mode = "n";
      action = "zE";
      silent = true;
      desc = "Delete all folds";
    }
  ];
}