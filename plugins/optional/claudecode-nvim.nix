# claudecode.nvim - Claude Code IDE integration for Neovim
# https://github.com/coder/claudecode.nvim
#
# Pure-Lua implementation of the WebSocket MCP protocol used by Claude Code's
# official VS Code/JetBrains extensions. Requires the `claude` CLI on PATH.
#
# Also wires up the two fzf-lua companions, which depend on fzf-lua
# (enabled in plugins/default.nix) and on claudecode itself.

{ pkgs, ... }:
let
  # Strip the nixpkgs-propagated `dependencies` from the fzf companions.
  # Those drag fzf-lua into nvf's /start pack while nvf's own fzf-lua module
  # keeps it lazy-loaded in /opt, so it would be installed under both. Every
  # dependency is already accounted for: fzf-lua by plugins/default.nix, and
  # claudecode by the entry below.
  withoutDeps =
    plugin:
    plugin.overrideAttrs (_: {
      dependencies = [ ];
    });
in
{
  config.vim = {
    extraPlugins = {
      claudecode = {
        package = pkgs.vimPlugins.claudecode-nvim;
        # snacks.nvim provides the terminal; it must be set up first
        after = [ "snacks-nvim" ];
        setup = ''
          require('claudecode').setup({
            -- Server
            auto_start = true,
            log_level = "info",

            -- terminal_cmd is deliberately unset. The default resolves
            -- "claude" from PATH, which picks up the user's own install
            -- rather than pinning whatever version nixpkgs happens to hold.

            -- Anchor Claude's cwd to the git root of the current file
            git_repo_cwd = true,

            -- Selection tracking
            track_selection = true,
            visual_demotion_delay_ms = 50,
            focus_after_send = false,

            terminal = {
              provider = "snacks",
              split_side = "right",
              split_width_percentage = 0.30,
              auto_close = true,
            },

            diff_opts = {
              layout = "vertical",
              open_in_new_tab = false,
              keep_terminal_focus = false,
            },
          })
        '';
      };

      claude-fzf = {
        package = withoutDeps pkgs.vimPlugins.claude-fzf-nvim;
        after = [ "claudecode" ];
        setup = ''
          require('claude-fzf').setup({
            auto_context = true,
            batch_size = 10,
            show_progress = true,
            auto_open_terminal = true,

            -- Keymaps live in binds/module/claudecode-nvim.nix. The plugin
            -- defaults (<leader>cf, <leader>cg, ...) would shadow the
            -- "+Diff Choose Options" <leader>c group in binds/diff-nvim.nix.
            keymaps = {},
          })
        '';
      };

      claude-fzf-history = {
        package = withoutDeps pkgs.vimPlugins.claude-fzf-history-nvim;
        after = [ "claudecode" ];
        setup = ''
          require('claude-fzf-history').setup({})
        '';
      };
    };

    # bat - used by claude-fzf-history for syntax-highlighted previews
    extraPackages = with pkgs; [ bat ];
  };
}
