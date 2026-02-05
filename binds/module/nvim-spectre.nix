{
  config.vim.keymaps = [
    # Themery keybindings
    {
      key = "<leader>S";
      mode = "n";
      silent = true;
      action = "<cmd>Spectre.toggle()<cr>";
      desc = "Toggle Spectre Find/Replace";
    }
    {
      key = "<leader>s";
      mode = "n";
      silent = true;
      action = "";
      desc = "+Spectre Find/Replace Options";
    }
    {
      key = "<leader>sw";
      mode = "n";
      silent = true;
      action = "<cmd>Spectre.open_visual({select_word=true})<cr>";
      desc = "Search current word";
    }
    {
      key = "<leader>sw";
      mode = "v";
      silent = true;
      action = "<cmd>Spectre.open_visual({select_word=true})<cr>";
      desc = "Search current word";
    }
    {
      key = "<leader>sp";
      mode = "n";
      silent = true;
      action = "<cmd>Spectre.open_file_search({select_word=true})<cr>";
      desc = "Search word on current file";
    }
  ];
}
