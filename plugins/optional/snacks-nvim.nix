# Snacks.nvim Plugin Configuration for nvf
# A collection of small QoL plugins for Neovim
# Documentation: https://github.com/folke/snacks.nvim

{ inputs, pkgs, ... }:
let
  snacks-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "snacks-nvim";
    src = inputs.snacks-nvim;
  };
in
{
  config.vim = {
    extraPlugins = {
      snacks = {
        package = snacks-from-source;
        setup = ''
          -- Snacks.nvim setup with priority and early loading
          require('snacks').setup({
            -- Core snacks that require setup
            bigfile = { 
              enabled = true,
              size = 1.5 * 1024 * 1024, -- 1.5MB
              ---@param ctx {buf: number, ft: string}
              setup = function(ctx)
                vim.cmd([[NoMatchParen]])
                vim.api.nvim_buf_set_option(ctx.buf, 'foldmethod', 'manual')
                vim.api.nvim_buf_set_option(ctx.buf, 'spell', false)
                vim.api.nvim_buf_set_option(ctx.buf, 'wrap', false)
                vim.api.nvim_buf_set_option(ctx.buf, 'undofile', false)
                vim.api.nvim_buf_set_option(ctx.buf, 'swapfile', false)
                vim.api.nvim_buf_set_option(ctx.buf, 'synmaxcol', 200)
              end,
            },
            
            dashboard = { 
              enabled = true,
              sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { section = "startup" },
              },
              preset = {
                keys = {
                  { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
                  { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                  { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
                  { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
                  { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                  { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
              },
            },
            
            explorer = { 
              enabled = true,
              replace_netrw = true,
            },
            
            indent = { 
              enabled = true,
              animate = {
                enabled = false, -- Disable animation for better performance in nvf
              },
            },
            
            input = { 
              enabled = true,
              -- Better vim.ui.input with nicer styling
            },
            
            notifier = {
              enabled = true,
              timeout = 3000,
              width = { min = 40, max = 0.4 },
              height = { min = 1, max = 0.6 },
              -- Enhanced notification styling
              style = "notification",
              top_down = true,
            },
            
            picker = { 
              enabled = true,
              win = {
                input = {
                  keys = {
                    ["<C-c>"] = { "close", mode = { "i", "n" } },
                    ["<Esc>"] = { "close", mode = { "i", "n" } },
                  },
                },
              },
            },
            
            quickfile = { 
              enabled = true,
              -- Fast file loading before plugins initialize
            },
            
            scope = { 
              enabled = true,
              -- Treesitter-based scope detection
              cursor = true,
              indent = {
                enabled = true,
              },
            },
            
            scroll = { 
              enabled = true,
              animate = {
                duration = { step = 15, total = 250 },
                easing = "linear",
              },
            },
            
            statuscolumn = { 
              enabled = true,
              left = { "mark", "sign" },
              right = { "fold", "git" },
              folds = {
                open = true,
                git_hl = true,
              },
              git = {
                patterns = { "GitSign", "MiniDiffSign" },
              },
              refresh = 50,
            },
            
            words = { 
              enabled = true,
              debounce = 200,
              -- Auto-show LSP references
            },
            
            -- Optional snacks (disabled by default for conservative setup)
            animate = { enabled = false },
            bufdelete = { enabled = false },
            debug = { enabled = false },
            dim = { enabled = false },
            git = { enabled = false },
            gitbrowse = { enabled = false },
            image = { enabled = false },
            lazygit = { enabled = false },
            layout = { enabled = false },
            notify = { enabled = false },
            profiler = { enabled = false },
            rename = { enabled = false },
            scratch = { enabled = false },
            terminal = { enabled = false },
            toggle = { enabled = false },
            util = { enabled = false },
            win = { enabled = false },
            zen = { enabled = false },
            
            -- Global styles for floating windows
            styles = {
              notification = {
                wo = { wrap = true },
                border = "rounded",
              },
              input = {
                border = "rounded",
              },
              picker = {
                border = "rounded",
              },
            },
          })

          -- Set up keymaps for core functionality
          local opts = { noremap = true, silent = true }

          -- File operations
          vim.keymap.set("n", "<leader>ff", function() require("snacks").picker.files() end, 
            vim.tbl_extend("force", opts, { desc = "Find Files" }))
          vim.keymap.set("n", "<leader>fr", function() require("snacks").picker.recent() end, 
            vim.tbl_extend("force", opts, { desc = "Recent Files" }))
          vim.keymap.set("n", "<leader>fg", function() require("snacks").picker.grep() end, 
            vim.tbl_extend("force", opts, { desc = "Grep Files" }))
          vim.keymap.set("n", "<leader>fb", function() require("snacks").picker.buffers() end, 
            vim.tbl_extend("force", opts, { desc = "Find Buffers" }))

          -- Explorer
          vim.keymap.set("n", "<leader>e", function() require("snacks").explorer() end, 
            vim.tbl_extend("force", opts, { desc = "Explorer" }))

          -- Notifications
          vim.keymap.set("n", "<leader>n", function() require("snacks").notifier.show_history() end, 
            vim.tbl_extend("force", opts, { desc = "Notification History" }))
          vim.keymap.set("n", "<leader>un", function() require("snacks").notifier.hide() end, 
            vim.tbl_extend("force", opts, { desc = "Dismiss Notifications" }))

          -- Dashboard
          vim.keymap.set("n", "<leader>d", function() require("snacks").dashboard.open() end, 
            vim.tbl_extend("force", opts, { desc = "Dashboard" }))

          -- Word navigation (if enabled)
          vim.keymap.set("n", "]]", function() require("snacks").words.jump(vim.v.count1) end, 
            vim.tbl_extend("force", opts, { desc = "Next Reference" }))
          vim.keymap.set("n", "[[", function() require("snacks").words.jump(-vim.v.count1) end, 
            vim.tbl_extend("force", opts, { desc = "Prev Reference" }))

          -- Set up late initialization for additional features
          vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
              -- Setup debugging globals (optional)
              _G.dd = function(...)
                require("snacks").debug.inspect(...)
              end
              _G.bt = function()
                require("snacks").debug.backtrace()
              end
              
              -- Override print for better debugging
              if vim.g.snacks_debug then
                vim.print = _G.dd
              end
            end,
          })
        '';
      };
    };
  };
}

