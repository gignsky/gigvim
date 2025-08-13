{
  config.vim.keymaps = [
    {
      key = "<leader>lo";
      mode = "n";
      action = "<cmd>lua require('otter').activate()<cr>";
      desc = "Activate Otter";
    }
    {
      key = "<leader>ld";
      mode = "n";
      action = "<cmd>lua require('otter').deactivate()<cr>";
      desc = "Deactivate Otter";
    }
    {
      key = "<leader>lr";
      mode = "n";
      action = "<cmd>lua require('otter').ask_rename()<cr>";
      desc = "Otter Rename";
    }
    {
      key = "<leader>lf";
      mode = "n";
      action = "<cmd>lua require('otter').ask_format()<cr>";
      desc = "Otter Format";
    }
    {
      key = "<leader>li";
      mode = "n";
      action = "<cmd>lua print(vim.inspect(require('otter').get_status()))<cr>";
      desc = "Otter Info";
    }
    {
      key = "<leader>le";
      mode = "n";
      action = "<cmd>lua require('otter').ask_hover()<cr>";
      desc = "Otter Hover/Eval";
    }
  ];
}