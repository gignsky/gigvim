# Snacks.nvim Developer Configuration Template  
# Development-focused snacks for enhanced coding experience
# Documentation: https://github.com/folke/snacks.nvim

{ inputs, pkgs, lib, ... }:
let
  snacks-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "snacks-nvim";
    src = inputs.snacks-nvim;
  };
in
{
  config.vim = {
    extraPlugins = {
      snacks-dev = {
        package = snacks-from-source;
        setup = ''
          -- Developer-focused Snacks.nvim setup
          require('snacks').setup({
            -- Core functionality
            bigfile = { 
              enabled = true,
              size = 1.5 * 1024 * 1024, -- 1.5MB
            },
            
            input = { 
              enabled = true,
            },
            
            notifier = {
              enabled = true,
              timeout = 3000,
              width = { min = 40, max = 0.4 },
              height = { min = 1, max = 0.6 },
            },
            
            quickfile = { 
              enabled = true,
            },
            
            -- Developer-specific features
            debug = { 
              enabled = true,
              -- Pretty inspect and backtraces for debugging
            },
            
            picker = { 
              enabled = true,
              win = {
                input = {
                  keys = {
                    ["<C-c>"] = { "close", mode = { "i", "n" } },
                    ["<Esc>"] = { "close", mode = { "i", "n" } },
                    ["<C-n>"] = { "select_next", mode = { "i", "n" } },
                    ["<C-p>"] = { "select_prev", mode = { "i", "n" } },
                  },
                },
              },
              sources = {
                files = {
                  hidden = false,
                  follow = true,
                  ignored = true,
                },
                grep = {
                  hidden = false,
                  follow = true,
                  ignored = true,
                },
              },
            },
            
            profiler = { 
              enabled = true,
              -- Performance profiling for Lua code
            },
            
            git = { 
              enabled = true,
            },
            
            gitbrowse = { 
              enabled = true,
              url_patterns = {
                ["github%.com"] = {
                  branch = "/tree/{branch}",
                  file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
                  commit = "/commit/{commit}",
                },
                ["gitlab%.com"] = {
                  branch = "/-/tree/{branch}",
                  file = "/-/blob/{branch}/{file}#L{line_start}-{line_end}",
                  commit = "/-/commit/{commit}",
                },
              },
            },
            
            lazygit = { 
              enabled = true,
              configure = true,
              win = {
                width = 0.9,
                height = 0.9,
                border = "rounded",
              },
            },
            
            rename = { 
              enabled = true,
              -- LSP-integrated file renaming
            },
            
            scratch = { 
              enabled = true,
              name = "scratch",
              ft = function()
                if vim.bo.buftype == "" and vim.bo.filetype == "" then
                  return "markdown"
                end
                return vim.bo.filetype
              end,
              root = vim.fn.stdpath("cache") .. "/scratch",
              autowrite = true,
              autohide = true,
              win_by_ft = {
                lua = {
                  keys = {
                    ["source"] = {
                      "<cr>",
                      function(self)
                        local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
                        Snacks.debug.run({ buf = self.buf, name = name })
                      end,
                      desc = "Source buffer",
                      mode = { "n", "x" },
                    },
                  },
                },
              },
            },
            
            terminal = { 
              enabled = true,
              shell = vim.o.shell,
              win = {
                style = "terminal",
                width = 0.8,
                height = 0.8,
                border = "rounded",
              },
            },
            
            toggle = { 
              enabled = true,
              notify = true,
              which_key = true,
              icon = {
                enabled = "󰔡 ",
                disabled = "󰨆 ",
              },
              color = {
                enabled = "green",
                disabled = "yellow",
              },
            },
            
            words = { 
              enabled = true,
              debounce = 200,
              notify_jump = false,
              notify_end = true,
              foldopen = true,
              jumplist = true,
              modes = { "n", "i", "c" },
            },
            
            scope = { 
              enabled = true,
              max_size = 50,
              min_size = 2,
              cursor = true,
              treesitter = {
                enabled = true,
                blocks = {
                  "function_item",
                  "function_definition", 
                  "method_definition",
                  "class_definition",
                  "do_statement",
                  "while_statement",
                  "repeat_statement",
                  "if_statement",
                  "for_statement",
                },
              },
            },
            
            indent = { 
              enabled = true,
              animate = {
                enabled = false, -- Disable for performance
              },
              scope = {
                enabled = true,
                animate = false,
              },
            },
            
            -- Disabled features for focused development experience
            animate = { enabled = false },
            bufdelete = { enabled = false },
            dashboard = { enabled = false },
            dim = { enabled = false },
            explorer = { enabled = false },
            image = { enabled = false },
            layout = { enabled = false },
            notify = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            util = { enabled = false },
            win = { enabled = false },
            zen = { enabled = false },
            
            -- Development-focused styles
            styles = {
              notification = {
                wo = { wrap = true },
                border = "rounded",
              },
              input = {
                border = "rounded",
                title_pos = "center",
              },
              picker = {
                border = "rounded",
                title_pos = "center",
                width = 0.8,
                height = 0.8,
              },
              terminal = {
                border = "rounded",
                title_pos = "center",
                width = 0.8,
                height = 0.8,
              },
            },
          })
          
          -- Developer-focused keymaps
          local opts = { noremap = true, silent = true }
          local snacks = require("snacks")
          
          -- File operations
          vim.keymap.set("n", "<leader><space>", function() snacks.picker.smart() end, 
            vim.tbl_extend("force", opts, { desc = "Smart Find Files" }))
          vim.keymap.set("n", "<leader>ff", function() snacks.picker.files() end, 
            vim.tbl_extend("force", opts, { desc = "Find Files" }))
          vim.keymap.set("n", "<leader>fr", function() snacks.picker.recent() end, 
            vim.tbl_extend("force", opts, { desc = "Recent Files" }))
          vim.keymap.set("n", "<leader>fg", function() snacks.picker.grep() end, 
            vim.tbl_extend("force", opts, { desc = "Grep Files" }))
          vim.keymap.set("n", "<leader>fb", function() snacks.picker.buffers() end, 
            vim.tbl_extend("force", opts, { desc = "Find Buffers" }))
          vim.keymap.set("n", "<leader>fc", function() snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, 
            vim.tbl_extend("force", opts, { desc = "Config Files" }))
          
          -- Git operations
          vim.keymap.set("n", "<leader>gb", function() snacks.picker.git_branches() end, 
            vim.tbl_extend("force", opts, { desc = "Git Branches" }))
          vim.keymap.set("n", "<leader>gl", function() snacks.picker.git_log() end, 
            vim.tbl_extend("force", opts, { desc = "Git Log" }))
          vim.keymap.set("n", "<leader>gs", function() snacks.picker.git_status() end, 
            vim.tbl_extend("force", opts, { desc = "Git Status" }))
          vim.keymap.set("n", "<leader>gB", function() snacks.gitbrowse() end, 
            vim.tbl_extend("force", opts, { desc = "Git Browse" }))
          vim.keymap.set("v", "<leader>gB", function() snacks.gitbrowse() end, 
            vim.tbl_extend("force", opts, { desc = "Git Browse" }))
          vim.keymap.set("n", "<leader>gg", function() snacks.lazygit() end, 
            vim.tbl_extend("force", opts, { desc = "LazyGit" }))
          
          -- LSP integration
          vim.keymap.set("n", "gd", function() snacks.picker.lsp_definitions() end, 
            vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
          vim.keymap.set("n", "gr", function() snacks.picker.lsp_references() end, 
            vim.tbl_extend("force", opts, { desc = "References" }))
          vim.keymap.set("n", "gI", function() snacks.picker.lsp_implementations() end, 
            vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
          vim.keymap.set("n", "gy", function() snacks.picker.lsp_type_definitions() end, 
            vim.tbl_extend("force", opts, { desc = "Goto Type Definition" }))
          vim.keymap.set("n", "<leader>ss", function() snacks.picker.lsp_symbols() end, 
            vim.tbl_extend("force", opts, { desc = "LSP Symbols" }))
          vim.keymap.set("n", "<leader>sS", function() snacks.picker.lsp_workspace_symbols() end, 
            vim.tbl_extend("force", opts, { desc = "LSP Workspace Symbols" }))
          
          -- Development tools
          vim.keymap.set("n", "<leader>.", function() snacks.scratch() end, 
            vim.tbl_extend("force", opts, { desc = "Toggle Scratch Buffer" }))
          vim.keymap.set("n", "<leader>S", function() snacks.scratch.select() end, 
            vim.tbl_extend("force", opts, { desc = "Select Scratch Buffer" }))
          
          vim.keymap.set("n", "<c-/>", function() snacks.terminal() end, 
            vim.tbl_extend("force", opts, { desc = "Toggle Terminal" }))
          vim.keymap.set("n", "<c-_>", function() snacks.terminal() end, 
            vim.tbl_extend("force", opts, { desc = "which_key_ignore" }))
          
          vim.keymap.set("n", "<leader>cR", function() snacks.rename.rename_file() end, 
            vim.tbl_extend("force", opts, { desc = "Rename File" }))
          
          -- Word navigation
          vim.keymap.set("n", "]]", function() snacks.words.jump(vim.v.count1) end, 
            vim.tbl_extend("force", opts, { desc = "Next Reference" }))
          vim.keymap.set("n", "[[", function() snacks.words.jump(-vim.v.count1) end, 
            vim.tbl_extend("force", opts, { desc = "Prev Reference" }))
          
          -- Notifications
          vim.keymap.set("n", "<leader>n", function() snacks.notifier.show_history() end, 
            vim.tbl_extend("force", opts, { desc = "Notification History" }))
          vim.keymap.set("n", "<leader>un", function() snacks.notifier.hide() end, 
            vim.tbl_extend("force", opts, { desc = "Dismiss All Notifications" }))
          
          -- Diagnostics and search
          vim.keymap.set("n", "<leader>sd", function() snacks.picker.diagnostics() end, 
            vim.tbl_extend("force", opts, { desc = "Diagnostics" }))
          vim.keymap.set("n", "<leader>sD", function() snacks.picker.diagnostics_buffer() end, 
            vim.tbl_extend("force", opts, { desc = "Buffer Diagnostics" }))
          vim.keymap.set("n", "<leader>sh", function() snacks.picker.help() end, 
            vim.tbl_extend("force", opts, { desc = "Help Pages" }))
          vim.keymap.set("n", "<leader>sk", function() snacks.picker.keymaps() end, 
            vim.tbl_extend("force", opts, { desc = "Keymaps" }))
          
          -- Setup late initialization for development features
          vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
              -- Setup debugging globals
              _G.dd = function(...) snacks.debug.inspect(...) end
              _G.bt = function() snacks.debug.backtrace() end
              vim.print = _G.dd
              
              -- Create useful toggle mappings for development
              snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
              snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
              snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
              snacks.toggle.diagnostics():map("<leader>ud")
              snacks.toggle.line_number():map("<leader>ul")
              snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
              snacks.toggle.treesitter():map("<leader>uT")
              snacks.toggle.inlay_hints():map("<leader>uh")
              snacks.toggle.indent():map("<leader>ug")
            end,
          })
        '';
      };
    };
  };
}