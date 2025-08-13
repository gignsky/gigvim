# Snacks.nvim - A collection of small QoL plugins for Neovim
# https://github.com/folke/snacks.nvim

{ inputs, pkgs, ... }:
let
  snacks-nvim-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "snacks-nvim";
    src = inputs.snacks-nvim; # Must match the input name in flake.nix
    doCheck = false; # Disable require check due to optional dependencies
  };
in
{
  config.vim.extraPlugins = {
    snacks-nvim = {
      package = snacks-nvim-from-source;
      setup = ''
        require('snacks').setup({
          -- Core performance and usability plugins
          bigfile = { enabled = true },
          quickfile = { enabled = true },
          
          -- Enhanced notification system with LSP progress
          notifier = { 
            enabled = true,
            timeout = 3000,
            style = "fancy",
            top_down = true,
          },
          
          -- Git integration
          lazygit = { 
            enabled = true,
            configure = true,
          },
          git = { enabled = true },
          gitbrowse = { enabled = true },
          
          -- UI enhancements
          dashboard = { 
            enabled = true,
            preset = {
              header = [[
  ██████  ██  ██████  ██    ██ ██ ███    ███ 
 ██       ██ ██       ██    ██ ██ ████  ████ 
 ██   ███ ██ ██   ███ ██    ██ ██ ██ ████ ██ 
 ██    ██ ██ ██    ██  ██  ██  ██ ██  ██  ██ 
  ██████  ██  ██████    ████   ██ ██      ██ 
                                              ]],
              keys = {
                { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
                { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
                { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
                { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
                { icon = " ", key = "q", desc = "Quit", action = ":qa" },
              },
            },
            sections = {
              { section = "header" },
              { section = "keys", gap = 1, padding = 1 },
            },
          },
          indent = { 
            enabled = true,
            scope = {
              enabled = true,
              priority = 200,
              char = "│",
              underline = false,
              only_scope = false,
              only_current = false,
            },
            chunk = {
              enabled = true,
              priority = 200,
              char = {
                corner_top = "┌",
                corner_bottom = "└",
                horizontal = "─",
                vertical = "│",
                arrow = ">",
              },
            },
            animate = {
              enabled = true,
              style = "out",
              easing = "linear",
              duration = 200,
            },
            filter = function(buf)
              return vim.g.snacks_indent ~= false
                and vim.b[buf].snacks_indent ~= false
                and vim.bo[buf].buftype == ""
            end,
          },
          dim = { 
            enabled = true,
            scope = {
              min_size = 5,
              max_size = 20,
              siblings = true,
            },
            animate = {
              enabled = true,
              easing = "outQuad",
              duration = 300,
            },
          },
          animate = { 
            enabled = true,
            fps = 60,
            easing = "outQuad",
          },
          
          -- Development tools
          bufdelete = { 
            enabled = true,
            notify = true,
          },
          explorer = { 
            enabled = true,
            replace_netrw = true,
          },
          input = { 
            enabled = true,
            win = {
              keys = {
                i_esc = { "<esc>", "cmp_close", "cancel" },
                i_cr = { "<cr>", { "cmp_accept", "confirm" } },
                i_tab = { "<tab>", { "cmp_select_next", "cmp_fallback" } },
              },
            },
          },
          picker = { 
            enabled = true,
            win = {
              input = {
                keys = {
                  ["<c-/>"] = { "help", mode = { "n", "i" } },
                },
              },
            },
          },
          
          -- Additional utilities
          debug = { enabled = true },
          health = { enabled = true },
          layout = { enabled = true },
          profiler = { enabled = true },
          
          -- Terminal and image support
          terminal = { enabled = true },
          image = { enabled = false }, # disabled since wsl2 doesn't support it
        })
      '';
    };
  };
}

