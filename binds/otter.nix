{
  config.vim.keymaps = [
    {
      key = "<leader>lo";
      mode = "n";
      action = "<cmd>lua require('otter').activate()<cr>";
      options.desc = "Activate Otter";
    }
    {
      key = "<leader>ld";
      mode = "n";
      action = "<cmd>lua require('otter').deactivate()<cr>";
      options.desc = "Deactivate Otter";
    }
    {
      key = "<leader>lr";
      mode = "n";
      action = "<cmd>lua require('otter').ask_rename()<cr>";
      options.desc = "Otter Rename";
    }
    {
      key = "<leader>lf";
      mode = "n";
      action = "<cmd>lua require('otter').ask_format()<cr>";
      options.desc = "Otter Format";
    }
    {
      key = "<leader>li";
      mode = "n";
      action = "<cmd>lua print(vim.inspect(require('otter').get_status()))<cr>";
      options.desc = "Otter Info";
    }
  ];
}