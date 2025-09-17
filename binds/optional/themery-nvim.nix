{
  config.vim.keymaps = [
    # Themery keybindings
    {
      key = "<leader>t";
      mode = "n";
      action = "";
      desc = "+Themes/Todo";
    }
    {
      key = "<leader>th";
      mode = "n";
      silent = true;
      action = "<cmd>Themery<cr>";
      desc = "Open Theme Selector";
    }
    # {
    #   key = "<leader>tt";
    #   mode = "n";
    #   silent = true;
    #   action = "<cmd>ThemeryToggle<cr>";
    #   desc = "Toggle Theme Variant";
    # }
  ];
}
