{
  config.vim.keymaps = [
    # WhichKey group description for git-dev
    {
      key = "<leader>gv";
      mode = "n";
      action = "";
      desc = "+Git Dev";
    }

    # git-dev.nvim keybinds
    {
      key = "<leader>gvo";
      mode = "n";
      silent = true;
      action = "<cmd>lua vim.ui.input({prompt = 'Repository to open: '}, function(repo) if repo and repo ~= '' then vim.cmd('GitDevOpen ' .. repo) end end)<cr>";
      desc = "Open remote repository";
    }
    {
      key = "<leader>gvr";
      mode = "n";
      silent = true;
      action = "<cmd>GitDevRecents<cr>";
      desc = "Browse recent repositories";
    }
    {
      key = "<leader>gvc";
      mode = "n";
      silent = true;
      action = "<cmd>GitDevClean<cr>";
      desc = "Clean current repository";
    }
    {
      key = "<leader>gvC";
      mode = "n";
      silent = true;
      action = "<cmd>GitDevCleanAll<cr>";
      desc = "Clean all cached repositories";
    }
    {
      key = "<leader>gvb";
      mode = "n";
      silent = true;
      action = "<cmd>GitDevCloseBuffers<cr>";
      desc = "Close all buffers for current repository";
    }
    {
      key = "<leader>gvu";
      mode = "n";
      silent = true;
      action = "<cmd>GitDevToggleUI<cr>";
      desc = "Toggle git-dev output window";
    }
  ];
}
