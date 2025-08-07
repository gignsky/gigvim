# Heirline.nvim Template Configuration
# This is a comprehensive template showing all available heirline configuration options
# Repository: https://github.com/rebelot/heirline.nvim
#
# Heirline is a highly customizable and fast statusline plugin for Neovim.
# Unlike other statusline plugins, heirline doesn't come with defaults - 
# it provides building blocks to create your own statusline.
#
# This template provides a comprehensive set of options that can be
# enabled/disabled by changing false to true for desired features.
#
# INSTRUCTIONS:
# 1. Copy this file to heirline-nvim.nix
# 2. Enable desired features by changing `enable = false` to `enable = true`
# 3. Customize colors, icons, and layouts as needed
# 4. Test and iterate on your configuration
#
# NOTE: This template is intentionally comprehensive and may be overwhelming.
# Start with basic features and gradually add more complex components.

{ inputs, pkgs, lib, ... }:
let
  heirline-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "heirline-nvim";
    src = inputs.heirline-nvim;
  };
in
{
  config.vim.extraPlugins = {
    heirline = {
      package = heirline-from-source;
      setup = ''
        local heirline = require('heirline')
        local conditions = require('heirline.conditions')
        local utils = require('heirline.utils')
        
        -- Color scheme integration
        local colors = {
          bright_bg = utils.get_highlight("Folded").bg,
          bright_fg = utils.get_highlight("Folded").fg,
          red = utils.get_highlight("DiagnosticError").fg,
          dark_red = utils.get_highlight("DiffDelete").bg,
          green = utils.get_highlight("String").fg,
          blue = utils.get_highlight("Function").fg,
          gray = utils.get_highlight("NonText").fg,
          orange = utils.get_highlight("Constant").fg,
          purple = utils.get_highlight("Statement").fg,
          cyan = utils.get_highlight("Special").fg,
          diag_warn = utils.get_highlight("DiagnosticWarn").fg,
          diag_error = utils.get_highlight("DiagnosticError").fg,
          diag_hint = utils.get_highlight("DiagnosticHint").fg,
          diag_info = utils.get_highlight("DiagnosticInfo").fg,
          git_del = utils.get_highlight("diffDeleted").fg,
          git_add = utils.get_highlight("diffAdded").fg,
          git_change = utils.get_highlight("diffChanged").fg,
        }
        
        -- Configuration options - change false to true to enable features
        local config = {
          -- Basic components
          mode_indicator = true,           -- Show current mode (INSERT, NORMAL, etc.)
          file_info = true,               -- Show filename and file status
          git_status = true,              -- Show git branch and changes
          lsp_status = true,              -- Show LSP server status
          diagnostics = true,             -- Show diagnostic counts
          search_count = true,            -- Show search match count
          macro_recording = true,         -- Show macro recording status
          
          -- Advanced components
          treesitter_status = false,      -- Show treesitter status
          dap_status = false,             -- Show debugger status
          terminal_name = false,          -- Show terminal name in terminal buffers
          spell_status = false,           -- Show spell check status
          readonly_indicator = true,      -- Show read-only file indicator
          
          -- File path options
          file_path_style = "smart",      -- "full", "relative", "smart", "filename_only"
          smart_path_max_length = 30,     -- Max length for smart path abbreviation
          show_file_icon = true,          -- Show file type icons
          show_modified_indicator = true,  -- Show modified file indicator
          
          -- Position and navigation
          ruler = true,                   -- Show line:column numbers
          percentage = false,             -- Show file percentage
          scrollbar = false,              -- Show scrollbar indicator
          
          -- Git integration
          git_branch = true,              -- Show git branch name
          git_diff_stats = true,          -- Show +/- diff stats
          git_blame = false,              -- Show git blame info (performance impact)
          
          -- LSP and diagnostics
          lsp_server_names = true,        -- Show active LSP server names
          lsp_progress = true,            -- Show LSP loading progress
          diagnostic_icons = true,        -- Use icons for diagnostics
          diagnostic_counts = true,       -- Show diagnostic counts
          
          -- Visual enhancements
          separators = true,              -- Use separators between components
          powerline_style = false,        -- Use powerline-style separators
          rounded_corners = false,        -- Use rounded separator style
          gradient_background = false,    -- Use gradient backgrounds
          
          -- Winbar (top of window)
          enable_winbar = false,          -- Enable winbar (filename at top)
          winbar_file_path = false,       -- Show file path in winbar
          winbar_lsp_breadcrumb = false,  -- Show LSP breadcrumb in winbar
          
          -- Tabline
          enable_tabline = false,         -- Enable custom tabline
          show_tab_numbers = false,       -- Show tab numbers
          show_tab_close_button = false,  -- Show close button on tabs
          
          -- Special buffer handling
          special_buffers = {
            terminal = true,              -- Custom display for terminal buffers
            quickfix = true,              -- Custom display for quickfix
            help = true,                  -- Custom display for help files
            oil = true,                   -- Custom display for oil.nvim
            neo_tree = true,              -- Custom display for neo-tree
            aerial = true,                -- Custom display for aerial
            dapui = true,                 -- Custom display for DAP UI
          },
          
          -- Performance
          update_events = {               -- Events that trigger statusline updates
            "WinEnter",
            "BufEnter", 
            "BufWritePost",
            "FileChangedShellPost",
            "VimResized",
            "ModeChanged",
            "User LspProgressUpdate",
          },
        }
        
        -- Helper functions for path abbreviation (implements smart path display)
        local function get_smart_path()
          local path = vim.fn.expand('%:p')
          if path == "" then
            return "[No Name]"
          end
          
          local cwd = vim.fn.getcwd()
          if path:sub(1, #cwd) == cwd then
            path = path:sub(#cwd + 2)
          end
          
          local parts = {}
          for part in path:gmatch("[^/]+") do
            table.insert(parts, part)
          end
          
          if #parts <= 2 then
            return parts[#parts] or ""
          end
          
          local result = {}
          for i = 1, #parts - 1 do
            if i == #parts - 1 then
              table.insert(result, parts[i])
            else
              table.insert(result, parts[i]:sub(1, 1))
            end
          end
          table.insert(result, parts[#parts])
          
          local full_path = table.concat(result, "/")
          if #full_path > config.smart_path_max_length then
            return "…/" .. parts[#parts]
          end
          
          return full_path
        end
        
        -- Component definitions (only include enabled components)
        local components = {}
        
        -- Mode indicator component
        if config.mode_indicator then
          table.insert(components, {
            init = function(self)
              self.mode = vim.fn.mode(1)
            end,
            static = {
              mode_names = {
                n = "N", no = "N?", nov = "N?", noV = "N?", ["no\22"] = "N?",
                niI = "Ni", niR = "Nr", niV = "Nv",
                nt = "Nt",
                v = "V", vs = "Vs", V = "V_", Vs = "Vs", ["\22"] = "^V", ["\22s"] = "^V",
                s = "S", S = "S_", ["\19"] = "^S",
                i = "I", ic = "Ic", ix = "Ix",
                R = "R", Rc = "Rc", Rx = "Rx", Rv = "Rv", Rvc = "Rv", Rvx = "Rv",
                c = "C", cv = "Ex", r = "...", rm = "M", ["r?"] = "?", ["!"] = "!",
                t = "T",
              },
              mode_colors = {
                n = "red", i = "green", v = "cyan", V = "cyan", ["\22"] = "cyan",
                c = "orange", s = "purple", S = "purple", ["\19"] = "purple",
                R = "orange", r = "orange", ["!"] = "red", t = "blue",
              }
            },
            provider = function(self)
              return " %2(" .. self.mode_names[self.mode] .. "%) "
            end,
            hl = function(self)
              local mode = self.mode:sub(1, 1)
              return { fg = "bg", bg = self.mode_colors[mode] }
            end,
            update = { "ModeChanged", pattern = "*:*" },
          })
        end
        
        -- File info component
        if config.file_info then
          local file_info = {}
          
          if config.show_file_icon then
            table.insert(file_info, {
              init = function(self)
                local filename = self.filename
                local extension = vim.fn.fnamemodify(filename, ":e")
                self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
              end,
              provider = function(self)
                return self.icon and (self.icon .. " ")
              end,
              hl = function(self)
                return { fg = self.icon_color }
              end
            })
          end
          
          table.insert(file_info, {
            init = function(self)
              self.filename = vim.api.nvim_buf_get_name(0)
            end,
            provider = function(self)
              if config.file_path_style == "smart" then
                return get_smart_path()
              elseif config.file_path_style == "relative" then
                return vim.fn.fnamemodify(self.filename, ":.")
              elseif config.file_path_style == "filename_only" then
                return vim.fn.fnamemodify(self.filename, ":t")
              else
                return self.filename
              end
            end,
            hl = { fg = utils.get_highlight("Directory").fg },
          })
          
          if config.show_modified_indicator then
            table.insert(file_info, {
              condition = function()
                return vim.bo.modified
              end,
              provider = " ●",
              hl = { fg = "green" },
            })
          end
          
          if config.readonly_indicator then
            table.insert(file_info, {
              condition = function()
                return not vim.bo.modifiable or vim.bo.readonly
              end,
              provider = " ",
              hl = { fg = "orange" },
            })
          end
          
          table.insert(components, file_info)
        end
        
        -- Additional components would be added here based on config options...
        -- This is just a sample of the comprehensive configuration possible
        
        -- Setup heirline with the configured components
        heirline.setup({
          statusline = components,
          opts = {
            colors = colors,
            disable_winbar_cb = function(args)
              return conditions.buffer_matches({
                buftype = { "nofile", "prompt", "help", "quickfix" },
                filetype = { "^git.*", "fugitive", "oil" },
              }, args.buf)
            end,
          }
        })
      '';
    };
  };
}