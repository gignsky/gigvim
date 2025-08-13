{
  config.vim.keymaps = [
    # git-dev.nvim keybinds
    {
      key = "<leader>go";
      mode = "n";
      silent = true;
      action = ":GitDevOpen ";
      desc = "Open remote repository";
    }
    {
      key = "<leader>gr";
      mode = "n";
      silent = true;
      action = ":GitDevRecents<CR>";
      desc = "Browse recent repositories";
    }
    {
      key = "<leader>gc";
      mode = "n";
      silent = true;
      action = ":GitDevClean<CR>";
      desc = "Clean current repository";
    }
    {
      key = "<leader>gC";
      mode = "n";
      silent = true;
      action = ":GitDevCleanAll<CR>";
      desc = "Clean all cached repositories";
    }
    {
      key = "<leader>gb";
      mode = "n";
      silent = true;
      action = ":GitDevCloseBuffers<CR>";
      desc = "Close all buffers for current repository";
    }
    {
      key = "<leader>gu";
      mode = "n";
      silent = true;
      action = ":GitDevToggleUI<CR>";
      desc = "Toggle git-dev output window";
    }
  ];
}
