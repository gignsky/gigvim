{
  config.vim.keymaps = [
    {
      key = "jj";
      mode = "i";
      silent = true;
      action = "<Esc>";
    }
    # git-dev.nvim keybinds
    {
      key = "<leader>go";
      mode = "n";
      silent = true;
      action = ":GitDevOpen ";
      description = "Open remote repository";
    }
    {
      key = "<leader>gr";
      mode = "n";
      silent = true;
      action = ":GitDevRecents<CR>";
      description = "Browse recent repositories";
    }
    {
      key = "<leader>gc";
      mode = "n";
      silent = true;
      action = ":GitDevClean<CR>";
      description = "Clean current repository";
    }
    {
      key = "<leader>gC";
      mode = "n";
      silent = true;
      action = ":GitDevCleanAll<CR>";
      description = "Clean all cached repositories";
    }
    {
      key = "<leader>gb";
      mode = "n";
      silent = true;
      action = ":GitDevCloseBuffers<CR>";
      description = "Close all buffers for current repository";
    }
    {
      key = "<leader>gu";
      mode = "n";
      silent = true;
      action = ":GitDevToggleUI<CR>";
      description = "Toggle git-dev output window";
    }
  ];
}
