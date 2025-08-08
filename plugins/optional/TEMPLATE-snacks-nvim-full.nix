# Snacks.nvim Full Configuration Template
# This template includes all available snacks with extensive configuration options
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
      snacks-full = {
        package = snacks-from-source;
        setup = ''
          -- Full Snacks.nvim setup with all features enabled
          require('snacks').setup({
            -- Animation system
            animate = { 
              enabled = true,
              duration = 20,
              easing = "linear",
              fps = 60,
            },
            
            -- Big file handling
            bigfile = { 
              enabled = true,
              size = 1.5 * 1024 * 1024, -- 1.5MB
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
            
            -- Buffer deletion
            bufdelete = { 
              enabled = true,
            },
            
            -- Dashboard
            dashboard = { 
              enabled = true,
              sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { section = "startup" },
                { section = "mru", limit = 10, gap = 1, padding = 1 },
                { section = "projects", limit = 8 },
              },
              preset = {
                header = [[
 ██████╗ ██╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
██╔════╝ ██║██╔════╝ ██║   ██║██║████╗ ████║
██║  ███╗██║██║  ███╗██║   ██║██║██╔████╔██║
██║   ██║██║██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
╚██████╔╝██║╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═════╝ ╚═╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
                keys = {
                  { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
                  { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                  { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
                  { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
                  { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
                  { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                  { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                  { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
              },
            },
            
            -- Debug utilities
            debug = { 
              enabled = true,
              -- Pretty inspect and backtraces
            },
            
            -- Dimming inactive scope
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
            
            -- File explorer
            explorer = { 
              enabled = true,
              replace_netrw = true,
              win = {
                width = 40,
                height = 0.8,
                border = "rounded",
              },
            },
            
            -- Git utilities
            git = { 
              enabled = true,
            },
            
            -- Git browse
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
            
            -- Image viewing
            image = { 
              enabled = true,
              backends = { "kitty", "viu" },
              integrations = {
                markdown = {
                  enabled = true,
                  clear_in_insert_mode = false,
                  download_images = false,
                  only_render_image_at_cursor = false,
                  filetypes = { "markdown", "vimwiki" },
                },
              },
            },
            
            -- Indent guides
            indent = { 
              enabled = true,
              animate = {
                enabled = true,
                duration = {
                  step = 20,
                  total = 500,
                },
                easing = "linear",
              },
              chunk = {
                enabled = true,
                only_current = false,
                priority = 200,
                hl = {
                  "SnacksIndentChunk1",
                  "SnacksIndentChunk2",
                  "SnacksIndentChunk3",
                  "SnacksIndentChunk4",
                  "SnacksIndentChunk5",
                  "SnacksIndentChunk6",
                  "SnacksIndentChunk7",
                  "SnacksIndentChunk8",
                },
              },
              scope = {
                enabled = true,
                animate = true,
                priority = 200,
                hl = {
                  "SnacksIndentScope1",
                  "SnacksIndentScope2",
                  "SnacksIndentScope3",
                  "SnacksIndentScope4",
                  "SnacksIndentScope5",
                  "SnacksIndentScope6",
                  "SnacksIndentScope7",
                  "SnacksIndentScope8",
                },
              },
            },
            
            -- Input replacement
            input = { 
              enabled = true,
              icon = " ",
              icon_hl = "SnacksInputIcon",
              icon_pos = "left",
              prompt_pos = "title",
              win = { style = "input" },
            },
            
            -- Layout management
            layout = { 
              enabled = true,
              preset = {
                layout = {
                  box = "horizontal",
                  { box = "vertical", { win = "main" }, { win = "footer", height = 3 } },
                  { box = "vertical", width = 40, { win = "left" }, { win = "left_footer", height = 3 } },
                },
              },
            },
            
            -- LazyGit integration
            lazygit = { 
              enabled = true,
              configure = true,
              win = {
                width = 0.9,
                height = 0.9,
                border = "rounded",
              },
            },
            
            -- Notifications
            notifier = {
              enabled = true,
              timeout = 3000,
              width = { min = 40, max = 0.4 },
              height = { min = 1, max = 0.6 },
              margin = { top = 0, right = 1, bottom = 0 },
              padding = true,
              sort = { "level", "added" },
              level = vim.log.levels.TRACE,
              icons = {
                error = " ",
                warn = " ",
                info = " ",
                debug = " ",
                trace = " ",
              },
              keep = function(notif)
                return vim.fn.fnamemodify(notif.msg[1], ":t") ~= "mini.starter"
              end,
            },
            
            -- Notify utilities
            notify = { 
              enabled = true,
            },
            
            -- Picker
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
            
            -- Profiler
            profiler = { 
              enabled = true,
              -- Lua profiler for performance analysis
            },
            
            -- Quick file loading
            quickfile = { 
              enabled = true,
              exclude = { "gitcommit", "gitrebase" },
            },
            
            -- File renaming
            rename = { 
              enabled = true,
              -- LSP-integrated file renaming
            },
            
            -- Scope detection
            scope = { 
              enabled = true,
              max_size = 50,
              min_size = 2,
              edge = true,
              cursor = true,
              indent = {
                enabled = true,
                only_current = false,
              },
              chunk = {
                enabled = true,
                only_current = false,
              },
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
            
            -- Scratch buffers
            scratch = { 
              enabled = true,
              name = "scratch",
              ft = function()
                if vim.bo.buftype == "" and vim.bo.filetype == "" then
                  return "markdown"
                end
                return vim.bo.filetype
              end,
              icon = nil,
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
            
            -- Smooth scrolling
            scroll = { 
              enabled = true,
              animate = {
                duration = { step = 15, total = 250 },
                easing = "linear",
              },
              spamming = 10,
              -- Smooth scrolling for better UX
            },
            
            -- Status column
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
            
            -- Terminal
            terminal = { 
              enabled = true,
              shell = vim.o.shell,
              win = {
                style = "terminal",
              },
            },
            
            -- Toggle utilities
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
            
            -- Utility functions
            util = { 
              enabled = true,
            },
            
            -- Window management
            win = { 
              enabled = true,
              -- Advanced window creation and management
            },
            
            -- LSP word references
            words = { 
              enabled = true,
              debounce = 200,
              notify_jump = false,
              notify_end = true,
              foldopen = true,
              jumplist = true,
              modes = { "n", "i", "c" },
            },
            
            -- Zen mode
            zen = { 
              enabled = true,
              toggles = {
                dim = true,
                git_signs = false,
                mini_diff_signs = false,
                diagnostics = false,
                inlay_hints = false,
              },
              show = {
                tabline = false,
                statusline = false,
              },
              win = {
                width = 0.8,
                height = 0.8,
              },
            },
            
            -- Global styles
            styles = {
              notification = {
                wo = { wrap = true },
                border = "rounded",
                zindex = 100,
                ft = "markdown",
              },
              input = {
                border = "rounded",
                title_pos = "center",
                icon_pos = "left",
                relative = "editor",
                zindex = 10,
                width = 60,
                height = 1,
                row = "50%",
                col = "50%",
              },
              picker = {
                border = "rounded",
                title_pos = "center",
                relative = "editor",
                zindex = 10,
                width = 0.8,
                height = 0.8,
                row = "50%",
                col = "50%",
              },
              terminal = {
                border = "rounded",
                title_pos = "center",
                relative = "editor",
                zindex = 10,
                width = 0.8,
                height = 0.8,
                row = "50%",
                col = "50%",
              },
            },
          })
          
          -- Comprehensive keymaps for all features
          local opts = { noremap = true, silent = true }
          local snacks = require("snacks")
          
          -- Top-level pickers
          vim.keymap.set("n", "<leader><space>", function() snacks.picker.smart() end, 
            vim.tbl_extend("force", opts, { desc = "Smart Find Files" }))
          vim.keymap.set("n", "<leader>,", function() snacks.picker.buffers() end, 
            vim.tbl_extend("force", opts, { desc = "Buffers" }))
          vim.keymap.set("n", "<leader>/", function() snacks.picker.grep() end, 
            vim.tbl_extend("force", opts, { desc = "Grep" }))
          vim.keymap.set("n", "<leader>:", function() snacks.picker.command_history() end, 
            vim.tbl_extend("force", opts, { desc = "Command History" }))
          
          -- File operations
          vim.keymap.set("n", "<leader>ff", function() snacks.picker.files() end, 
            vim.tbl_extend("force", opts, { desc = "Find Files" }))
          vim.keymap.set("n", "<leader>fr", function() snacks.picker.recent() end, 
            vim.tbl_extend("force", opts, { desc = "Recent Files" }))
          vim.keymap.set("n", "<leader>fg", function() snacks.picker.git_files() end, 
            vim.tbl_extend("force", opts, { desc = "Git Files" }))
          vim.keymap.set("n", "<leader>fc", function() snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, 
            vim.tbl_extend("force", opts, { desc = "Config Files" }))
          
          -- Explorer
          vim.keymap.set("n", "<leader>e", function() snacks.explorer() end, 
            vim.tbl_extend("force", opts, { desc = "Explorer" }))
          
          -- Git
          vim.keymap.set("n", "<leader>gb", function() snacks.picker.git_branches() end, 
            vim.tbl_extend("force", opts, { desc = "Git Branches" }))
          vim.keymap.set("n", "<leader>gl", function() snacks.picker.git_log() end, 
            vim.tbl_extend("force", opts, { desc = "Git Log" }))
          vim.keymap.set("n", "<leader>gs", function() snacks.picker.git_status() end, 
            vim.tbl_extend("force", opts, { desc = "Git Status" }))
          vim.keymap.set("n", "<leader>gB", function() snacks.gitbrowse() end, 
            vim.tbl_extend("force", opts, { desc = "Git Browse" }))
          vim.keymap.set("n", "<leader>gg", function() snacks.lazygit() end, 
            vim.tbl_extend("force", opts, { desc = "LazyGit" }))
          
          -- Notifications
          vim.keymap.set("n", "<leader>n", function() snacks.notifier.show_history() end, 
            vim.tbl_extend("force", opts, { desc = "Notification History" }))
          vim.keymap.set("n", "<leader>un", function() snacks.notifier.hide() end, 
            vim.tbl_extend("force", opts, { desc = "Dismiss All Notifications" }))
          
          -- Buffers
          vim.keymap.set("n", "<leader>bd", function() snacks.bufdelete() end, 
            vim.tbl_extend("force", opts, { desc = "Delete Buffer" }))
          
          -- Scratch
          vim.keymap.set("n", "<leader>.", function() snacks.scratch() end, 
            vim.tbl_extend("force", opts, { desc = "Toggle Scratch Buffer" }))
          vim.keymap.set("n", "<leader>S", function() snacks.scratch.select() end, 
            vim.tbl_extend("force", opts, { desc = "Select Scratch Buffer" }))
          
          -- Terminal
          vim.keymap.set("n", "<c-/>", function() snacks.terminal() end, 
            vim.tbl_extend("force", opts, { desc = "Toggle Terminal" }))
          vim.keymap.set("n", "<c-_>", function() snacks.terminal() end, 
            vim.tbl_extend("force", opts, { desc = "which_key_ignore" }))
          
          -- Zen mode
          vim.keymap.set("n", "<leader>z", function() snacks.zen() end, 
            vim.tbl_extend("force", opts, { desc = "Toggle Zen Mode" }))
          vim.keymap.set("n", "<leader>Z", function() snacks.zen.zoom() end, 
            vim.tbl_extend("force", opts, { desc = "Toggle Zoom" }))
          
          -- Word navigation
          vim.keymap.set("n", "]]", function() snacks.words.jump(vim.v.count1) end, 
            vim.tbl_extend("force", opts, { desc = "Next Reference" }))
          vim.keymap.set("n", "[[", function() snacks.words.jump(-vim.v.count1) end, 
            vim.tbl_extend("force", opts, { desc = "Prev Reference" }))
          
          -- LSP integration
          vim.keymap.set("n", "gd", function() snacks.picker.lsp_definitions() end, 
            vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
          vim.keymap.set("n", "gr", function() snacks.picker.lsp_references() end, 
            vim.tbl_extend("force", opts, { desc = "References" }))
          vim.keymap.set("n", "gI", function() snacks.picker.lsp_implementations() end, 
            vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
          vim.keymap.set("n", "gy", function() snacks.picker.lsp_type_definitions() end, 
            vim.tbl_extend("force", opts, { desc = "Goto Type Definition" }))
          
          -- File renaming
          vim.keymap.set("n", "<leader>cR", function() snacks.rename.rename_file() end, 
            vim.tbl_extend("force", opts, { desc = "Rename File" }))
          
          -- Toggles (if toggle is enabled)
          vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
              -- Setup debugging globals
              _G.dd = function(...) snacks.debug.inspect(...) end
              _G.bt = function() snacks.debug.backtrace() end
              vim.print = _G.dd
              
              -- Create toggle mappings
              snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
              snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
              snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
              snacks.toggle.diagnostics():map("<leader>ud")
              snacks.toggle.line_number():map("<leader>ul")
              snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
              snacks.toggle.treesitter():map("<leader>uT")
              snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
              snacks.toggle.inlay_hints():map("<leader>uh")
              snacks.toggle.indent():map("<leader>ug")
              snacks.toggle.dim():map("<leader>uD")
            end,
          })
        '';
      };
    };
  };
}