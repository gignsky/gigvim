{
  config.vim.keymaps = [
    # <leader>gd: Open the diff view for all uncommitted changes.
    # If Diffview is already open, this command will close it (a toggle effect).
    {
      key = "<leader>gd";
      action = "<cmd>DiffviewOpen<CR>";
      mode = "n";
      silent = true;
      desc = "Toggle Diffview (Working Tree)";
    }

    {
      key = "<leader>c";
      mode = "n";
      action = "";
      silent = true;
      desc = "+Diff Choose Options";
    }

    # <leader>gdh: Open the history view for the file in the current buffer.
    # This allows you to trace the lineage of the current file.
    {
      key = "<leader>gdh";
      mode = "n";
      action = "<cmd>DiffviewFileHistory %<CR>";
      silent = true;
      desc = "File History (Current File)";
    }

    # <leader>gdo: Open the diff view comparing the current state against the HEAD (last commit).
    # This is useful for reviewing your staged/unstaged changes before committing.
    {
      key = "<leader>gdo";
      mode = "n";
      action = "<cmd>DiffviewOpen HEAD<CR>";
      silent = true;
      desc = "Diff Against HEAD";
    }

    # <leader>gdc: Force-close Diffview entirely.
    # This is a dedicated close command, distinct from the toggle.
    {
      key = "<leader>gdc";
      action = "<cmd>DiffviewClose<CR>";
      mode = "n";
      silent = true;
      desc = "Close Diffview";
    }
  ];
}
