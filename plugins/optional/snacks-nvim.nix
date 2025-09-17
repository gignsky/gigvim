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
          bigfile = { 
            enabled = true,
            line_length = 250, -- Threshold for determining large files based on average line length
          },

          quickfile = { enabled = true },
          
          -- Enhanced notification system with LSP progress
          notifier = { 
            enabled = true,
            timeout = 30000,
            style = "fancy",
            top_down = true,
          },
          
          -- Git integration
          lazygit = { 
            enabled = true,
            configure = true,
            -- theme = {
            --   activeBorderColor = { "#a6da95", "bold" },
            --   inactiveBorderColor = { "#494d64" },
            --   optionsTextColor = { "#8bd5ca" },
            --   selectedLineBgColor = { "#363a4f" },
            --   selectedRangeBgColor = { "#363a4f" },
            --   cherryPickedCommitBgColor = { "#494d64" },
            --   cherryPickedCommitFgColor = { "#a6da95" },
            --   unstagedChangesColor = { "#ed8796" },
            --   defaultFgColor = { "#cad3f5" },
            -- },
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
                { icon = " ", key = "l", desc = "Open LazyGit", action = "<cmd>lua Snacks.lazygit()<cr>" },
                { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
                { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
                { icon = " ", key = "e", desc = "Toggle Explorer", action = ":lua Snacks.explorer()" },
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
              priority = 10,
              char = "│",
              underline = true,
              only_current = true,
            },
            chunk = {
              enabled = true,
              priority = 10,
              only_current = true,
              -- Configure chunk to point to final brace
              hl = "SnacksIndentChunk",
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
              easing = "linear", -- only linear is available
              duration = 50,
            },
            -- Filter function: only enable indent guides for normal buffers (not terminals, help, etc.)
            filter = function(buf)
              return vim.g.snacks_indent ~= false
                and vim.b[buf].snacks_indent ~= false
                and vim.bo[buf].buftype == ""
            end,
          },
          dim = { 
            enabled = true,
            -- Enable automatic dimming
            auto = true,
            scope = {
              min_size = 5,
              max_size = 20,
              siblings = true,
            },
            animate = {
              enabled = true,
              easing = "outQuad",  -- Available: linear, ease, easeIn, easeOut, easeInOut, outQuad, inQuad, etc.
              duration = 300,
            },
          },
          animate = { 
            enabled = true,
            fps = 120,
            easing = "outQuad",
            -- Enable window resize animations
            resize = {
              enabled = true,
              duration = 200,
            },
            -- Enable window movement animations  
            move = {
              enabled = true,
              duration = 200,
            },
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
                -- i_esc = { "<esc>", "cmp_close", "cancel" },
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
          debug = { 
            enabled = true,
            -- Enable debug logging
            log_level = "info",
          },
          health = { enabled = true },
          layout = { enabled = true },
          profiler = { 
            enabled = true,
            -- Auto start profiling on startup
            auto_start = false,
          },
          
          -- Enhanced UI features
          scope = { 
            enabled = true,
            priority = 200,
            animate = {
              enabled = true,
              duration = 200,
            },
          },
          scroll = { 
            enabled = true,
            animate = {
              duration = 7,
              easing = "outQuad",
            },
            spamming = 10,
          },
          statuscolumn = { 
            enabled = true,
            -- Organize gutter information for maximum clarity
            -- Left side: marks and diagnostic/LSP signs
            left = { "mark", "sign" },
            -- Right side: git information and folds
            right = { "git", "fold" },
            folds = {
              open = true,
              git_hl = true,
            },
            -- Enhanced git highlighting in status column
            git = {
              enabled = true,
            },
          },
          words = { 
            enabled = true,
            debounce = 200,
            notify_jump = true,
            notify_end = true,
          },
          
          -- Terminal and image support
          terminal = { 
           enabled = true,
           win = {
             position = "float",
             height = 0.9,
             width = 0.9,
           },
           shell = "nu",
         },
          image = { enabled = false }, -- disabled since wsl2 doesn't support it
        })

        -- Set up vim.ui.input to use snacks after setup
        vim.ui.input = require('snacks').input
      '';
    };
  };

  # Required dependencies for snacks.nvim functionality
  config.vim.extraPackages = with pkgs; [
    ripgrep # rg - required for grep functionality
    fd # fd - required for file finding (v8.4+)
    sqlite # sqlite3 - required for certain snacks features
    gscan2pdf # gs - required for image support
    tectonic.tectonic # tectonic - required for LaTeX support
    git # its git bitch
    # latex     # pdflatex - required for LaTeX support
    # mmdc         # mmdc - required for Markdown support
  ];
}
