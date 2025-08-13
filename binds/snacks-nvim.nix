{
  config.vim.keymaps = [
    # WhichKey group descriptions
    {
      key = "<leader>f";
      mode = "n";
      action = "";
      desc = "+Find/Files";
    }
    {
      key = "<leader>g";
      mode = "n";
      action = "";
      desc = "+Git";
    }
    {
      key = "<leader>b";
      mode = "n";
      action = "";
      desc = "+Buffers";
    }
    {
      key = "<leader>t";
      mode = "n";
      action = "";
      desc = "+Themes/Terminal";
    }
    {
      key = "<leader>n";
      mode = "n";
      action = "";
      desc = "+Notifications";
    }
    {
      key = "<leader>l";
      mode = "n";
      action = "";
      desc = "+Linter";
    }

    # Snacks.nvim keybindings
    {
      key = "<leader>gg";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.lazygit()<cr>";
      desc = "Open Lazygit";
    }
    {
      key = "<leader>e";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.explorer()<cr>";
      desc = "Toggle File Explorer";
    }
    {
      key = "<leader>ff";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.picker.files()<cr>";
      desc = "Find Files";
    }
    {
      key = "<leader>fb";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.picker.buffers()<cr>";
      desc = "Find Buffers";
    }
    {
      key = "<leader>fg";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.picker.grep()<cr>";
      desc = "Live Grep";
    }
    {
      key = "<leader>fr";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.picker.recent()<cr>";
      desc = "Recent Files";
    }
    {
      key = "<leader>fs";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.picker.symbols()<cr>";
      desc = "Find Symbols";
    }
    {
      key = "<leader>fk";
      mode = "n";
      silent = true;
      action = "<cmd>Telescope keymaps<cr>";
      desc = "Find Keymaps";
    }
    {
      key = "<leader>fc";
      mode = "n";
      silent = true;
      action = "<cmd>Telescope commands<cr>";
      desc = "Find Commands";
    }
    {
      key = "<leader>gf";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.picker.git_files()<cr>";
      desc = "Git Files";
    }

    # Git utilities
    {
      key = "<leader>gs";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.git.blame_line()<cr>";
      desc = "Git Blame Line";
    }

    # Buffer management
    {
      key = "<leader>bd";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.bufdelete()<cr>";
      desc = "Delete Buffer";
    }
    {
      key = "<leader>ba";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.bufdelete.all()<cr>";
      desc = "Delete All Buffers";
    }
    {
      key = "<leader>bo";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.bufdelete.other()<cr>";
      desc = "Delete Other Buffers";
    }

    # Terminal
    {
      key = "<leader>tf";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.terminal()<cr>";
      desc = "Toggle Floating Terminal";
    }

    # Notifications
    {
      key = "<leader>nh";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.notifier.show_history()<cr>";
      desc = "Notification History";
    }
    {
      key = "<leader>nd";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.notifier.hide()<cr>";
      desc = "Dismiss Notifications";
    }

    # Dashboard
    {
      key = "<leader>d";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.dashboard()<cr>";
      desc = "Return to Dashboard";
    }
  ];
}
