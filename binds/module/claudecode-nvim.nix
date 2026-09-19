# Keybindings for claudecode.nvim and its fzf-lua companions.
# Follows the upstream <leader>a layout from coder/claudecode.nvim, with the
# claude-fzf pickers folded into the same group on free letters.

{
  config.vim.keymaps = [
    # WhichKey group description
    {
      key = "<leader>a";
      mode = "n";
      action = "";
      desc = "+AI / Claude Code";
    }

    # Terminal lifecycle
    {
      key = "<leader>ac";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeCode<cr>";
      desc = "Toggle Claude";
    }
    {
      key = "<leader>af";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeCodeFocus<cr>";
      desc = "Focus Claude";
    }
    {
      key = "<leader>ar";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeCode --resume<cr>";
      desc = "Resume Claude";
    }
    {
      key = "<leader>aC";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeCode --continue<cr>";
      desc = "Continue Claude";
    }
    {
      key = "<leader>am";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeCodeSelectModel<cr>";
      desc = "Select Claude model";
    }

    # Context
    {
      key = "<leader>ab";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeCodeAdd %<cr>";
      desc = "Add current buffer";
    }
    {
      key = "<leader>as";
      mode = "v";
      silent = true;
      action = "<cmd>ClaudeCodeSend<cr>";
      desc = "Send selection to Claude";
    }

    # Diff management
    {
      key = "<leader>aa";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeCodeDiffAccept<cr>";
      desc = "Accept diff";
    }
    {
      key = "<leader>ad";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeCodeDiffDeny<cr>";
      desc = "Deny diff";
    }
    {
      key = "<leader>ax";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeCodeCloseAllDiffs<cr>";
      desc = "Close pending diffs";
    }

    # claude-fzf.nvim - batch context via fzf-lua multi-select
    {
      key = "<leader>aF";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeFzfFiles<cr>";
      desc = "Add files (fzf multi-select)";
    }
    {
      key = "<leader>ag";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeFzfGrep<cr>";
      desc = "Grep and add to context";
    }
    {
      key = "<leader>aB";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeFzfBuffers<cr>";
      desc = "Add buffers";
    }
    {
      key = "<leader>aG";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeFzfGitFiles<cr>";
      desc = "Add git files";
    }
    {
      key = "<leader>aD";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeFzfDirectory<cr>";
      desc = "Add directory files";
    }

    # claude-fzf-history.nvim
    {
      key = "<leader>ah";
      mode = "n";
      silent = true;
      action = "<cmd>ClaudeHistory<cr>";
      desc = "Claude conversation history";
    }
  ];
}
