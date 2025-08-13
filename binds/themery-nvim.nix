{
  config.vim.keymaps = [
    # Themery keybindings
    {
      key = "<leader>th";
      mode = "n";
      silent = true;
      action = ":Themery";
      desc = "Open Theme Selector";
    }
    {
      key = "<leader>tt";
      mode = "n";
      silent = true;
      action = ":ThemeryToggle";
      desc = "Toggle Theme Variant";
    }
  ];
}
