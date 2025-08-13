# git-dev.nvim - Open remote Git repositories inside Neovim
# https://github.com/moyiz/git-dev.nvim

{ inputs, pkgs, ... }:
let
  git-dev-nvim-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "git-dev-nvim";
    src = inputs.git-dev-nvim; # Must match the input name in flake.nix
  };
in
{
  config.vim.extraPlugins = {
    git-dev-nvim = {
      package = git-dev-nvim-from-source;
      setup = ''
        require('git-dev').setup({
          -- Whether to delete an opened repository when nvim exits.
          ephemeral = true,
          -- Set buffers of opened repositories to be read-only and unmodifiable.
          read_only = true,
          -- Whether / how to CD into opened repository.
          cd_type = "global",
          -- The actual `open` behavior.
          opener = function(dir, repo_uri, selected_path)
            require('git-dev').ui:print("Opening " .. repo_uri)
            local dest =
              vim.fn.fnameescape(selected_path and dir .. "/" .. selected_path or dir)
            vim.cmd("edit " .. dest)
          end,
          -- Location of cloned repositories. Should be dedicated for this purpose.
          repositories_dir = vim.fn.stdpath("cache") .. "/git-dev",
          git = {
            -- Name / path of `git` command.
            command = "git",
            -- Default organization if none is specified.
            default_org = nil,
            -- Base URI to use when given repository name is scheme-less.
            base_uri_format = "https://github.com/%s.git",
            -- Arguments for `git clone`.
            clone_args = "--jobs=2 --single-branch --recurse-submodules "
              .. "--shallow-submodules --progress",
            -- Arguments for `git fetch`.
            fetch_args = "--jobs=2 --no-all --update-shallow -f --prune --no-tags",
            -- Arguments for `git checkout`.
            checkout_args = "-f --recurse-submodules",
          },
          -- UI configuration.
          ui = {
            -- Whether to enable builtin output buffer or fallback to `vim.notify`.
            enabled = true,
            -- Auto-close window after repository was opened.
            auto_close = true,
            -- Delay window closing.
            close_after_ms = 3000,
            -- Window mode.
            mode = "floating",
            -- Window configuration for floating mode.
            floating_win_config = {
              title = "git-dev",
              title_pos = "center",
              anchor = "NE",
              style = "minimal",
              border = "rounded",
              relative = "editor",
              width = 79,
              height = 9,
              row = 1,
              col = vim.o.columns,
              noautocmd = true,
            },
          },
          -- History configuration.
          history = {
            -- Maximum number of records to keep in history.
            n = 32,
            -- Store file path.
            path = vim.fn.stdpath("data") .. "/git-dev/history.json",
          },
          -- Repository cleaning configuration.
          clean = {
            -- Close all related buffers.
            close_buffers = true,
            -- Whether to delete repository directory.
            delete_repo_dir = "current",
          },
        })
      '';
    };
  };
}