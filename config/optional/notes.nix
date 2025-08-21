_: {
  config.vim.notes = {
    todo-comments = {
      enable = true;
      setupOpts = {
        search = {
          args = [
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--glob=*.nix" # Include .nix files
          ];
          #   # Extend the default search patterns to include Nix comment syntax
          pattern = "\\b(KEYWORDS)(\\s*\\([^\\)]*\\))?\\s*:?";
        };
        highlight = {
          pattern = ".*<(KEYWORDS)(\\s*\\([^\\)]*\\))?\\s*:?";
          comments_only = true;
          keyword = "bg"; # Use wide_fg to include foreground styling
          before = ""; # No highlighting before the keyword
          after = "fg"; # Normal foreground color for text after
        };
        signs = true;
        sign_priority = 8;
        gui_style = {
          fg = "INVERSE";
          bg = "BOLD";
        };
      };
    };
  };
}
