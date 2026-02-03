{
  # This attribute set is passed directly to the plugin's setup function:
  # require('diffview').setup({...})
  config.vim.utility.diffview-nvim = {
    enable = true;
    setupOpts = {
      # 1. Diffing Behavior
      # Configuration for how binary files should be handled.
      # Options: "skip" (default) | "prompt" | "try"
      diff_binaries = "prompt";

      enhanced_diff_hl = false; # See |diffview-config-enhanced_diff_hl|
      git_cmd = [ "git" ]; # The git executable followed by default args.
      # hg_cmd = { "hg" };        # The hg executable followed by default args.
      use_icons = true; # Requires nvim-web-devicons
      show_help_hints = true; # Show hints for how to open the help panel
      watch_index = true; # Update views and index buffers when the git index changes.

      icons = {
        # Only applies when use_icons is true.
        folder_closed = "";
        folder_open = "";
      };

      signs = {
        fold_closed = "";
        fold_open = "";
        done = "✓";
      };

      # # 2. File Panel Configuration - DEPRECATED
      # file_panel = {
      #   # Sets the initial width of the file panel that lists the changed files.
      #   # A width of 30 is a reasonable default for visibility.
      #   width = 30;
      #
      #   # Determines if the file panel should be automatically focused when opening Diffview.
      #   # Setting this to false allows the diff windows to be focused immediately.
      #   win_on_top = false;
      # };

      # 3. View Layout Configuration
      view = {
        # Defines the default layout for diff views that compare two revisions
        # (e.g., when running :DiffviewOpen HEAD~1).
        # Common options: "diff2_vertical" (side-by-side) or "diff2_horizontal" (top-and-bottom).
        default_file_history_view = "diff3_mixed";
        # default_file_history_view = "diff4_mixed";

        # Allows the use of the mouse to resize the diff windows, providing
        # a more convenient interface.
        allow_resize = true;
      };

      # 4. Sorting Behavior
      # By default, files are sorted by path, but this option will add sorting by extension,
      # which can be useful for grouping file types together.
      sort_ext = true;
    };
  };
}
