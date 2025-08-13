{
  config.vim.keymaps = [
    # Snacks.nvim keybindings
    {
      key = "<leader>gg";
      mode = "n";
      silent = true;
      action = ":lua Snacks.lazygit()";
      desc = "Open Lazygit";
    }
    {
      key = "<leader>e";
      mode = "n";
      silent = true;
      action = ":lua Snacks.explorer()";
      desc = "Toggle File Explorer";
    }
    {
      key = "<leader>ff";
      mode = "n";
      silent = true;
      action = ":lua Snacks.picker.files()";
      desc = "Find Files";
    }
    {
      key = "<leader>fb";
      mode = "n";
      silent = true;
      action = ":lua Snacks.picker.buffers()";
      desc = "Find Buffers";
    }
    {
      key = "<leader>fg";
      mode = "n";
      silent = true;
      action = ":lua Snacks.picker.grep()";
      desc = "Live Grep";
    }
    {
      key = "<leader>fr";
      mode = "n";
      silent = true;
      action = ":lua Snacks.picker.recent()";
      desc = "Recent Files";
    }
    {
      key = "<leader>fs";
      mode = "n";
      silent = true;
      action = ":lua Snacks.picker.symbols()";
      desc = "Find Symbols";
    }
    {
      key = "<leader>gf";
      mode = "n";
      silent = true;
      action = ":lua Snacks.picker.git_files()";
      desc = "Git Files";
    }

    # Git utilities
    {
      key = "<leader>gs";
      mode = "n";
      silent = true;
      action = ":lua Snacks.git.blame_line()";
      desc = "Git Blame Line";
    }
    {
      key = "<leader>gS";
      mode = "n";
      silent = true;
      action = ":lua Snacks.git.status()";
      desc = "Git Status";
    }
    {
      key = "<leader>gb";
      mode = "n";
      silent = true;
      action = ":lua Snacks.git.branch()";
      desc = "Git Branch Info";
    }
    {
      key = "<leader>go";
      mode = "n";
      silent = true;
      action = ":lua Snacks.gitbrowse()";
      desc = "Open in Browser";
    }

    # Buffer management
    {
      key = "<leader>bd";
      mode = "n";
      silent = true;
      action = ":lua Snacks.bufdelete()";
      desc = "Delete Buffer";
    }
    {
      key = "<leader>ba";
      mode = "n";
      silent = true;
      action = ":lua Snacks.bufdelete.all()";
      desc = "Delete All Buffers";
    }
    {
      key = "<leader>bo";
      mode = "n";
      silent = true;
      action = ":lua Snacks.bufdelete.other()";
      desc = "Delete Other Buffers";
    }

    # Terminal
    {
      key = "<leader>t";
      mode = "n";
      silent = true;
      action = ":lua Snacks.terminal()";
      desc = "Toggle Terminal";
    }
  ];
}
