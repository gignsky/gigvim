{
  config.vim = {
    git = {
      enable = true;
      gitsigns = {
        enable = false;
        codeActions.enable = true;
        setupOpts = {
          signs = {
            add = {
              text = "+";
            };
            change = {
              text = "~";
            };
            delete = {
              text = "-";
            };
            topdelete = {
              text = "‾";
            };
            changedelete = {
              text = "~";
            };
            untracked = {
              text = "┆";
            };
          };
          signcolumn = true;
          numhl = false;
          linehl = false;
          word_diff = false;
          watch_gitdir = {
            follow_files = true;
          };
          attach_to_untracked = true;
          current_line_blame = false;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 1000;
            ignore_whitespace = false;
          };
          # # Compare against the base branch (main/master) instead of just index
          # base = "HEAD~1"; # This compares against the previous commit, can be changed to origin/main
          sign_priority = 6;
          update_debounce = 100;
          status_formatter = null;
          max_file_length = 40000;
          preview_config = {
            border = "single";
            style = "minimal";
            relative = "cursor";
            row = 0;
            col = 1;
          };
        };
      };
    };
  };
}
