{
  config.vim.keymaps = [
    # git-dev.nvim keybinds
    {
      key = "<leader>go";
      mode = "n";
      silent = true;
      action = "<cmd>lua require('snacks').input({prompt = 'Repository to open: '}, function(repo) if repo and repo ~= '' then vim.cmd('GitDevOpen ' .. repo) end end)<cr>";
      desc = "Open remote repository";
    }
    {
      key = "<leader>gr";
      mode = "n";
      silent = true;
      action = "<cmd>GitDevRecents<cr>";
      desc = "Browse recent repositories";
    }
    {
      key = "<leader>gc";
      mode = "n";
      silent = true;
      action = "<cmd>GitDevClean<cr>";
      desc = "Clean current repository";
    }
    {
      key = "<leader>gC";
      mode = "n";
      silent = true;
      action = "<cmd>GitDevCleanAll<cr>";
      desc = "Clean all cached repositories";
    }
    {
      key = "<leader>gb";
      mode = "n";
      silent = true;
      action = "<cmd>GitDevCloseBuffers<cr>";
      desc = "Close all buffers for current repository";
    }
    {
      key = "<leader>gu";
      mode = "n";
      silent = true;
      action = "<cmd>GitDevToggleUI<cr>";
      desc = "Toggle git-dev output window";
    }
  ];
}
