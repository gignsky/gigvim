# Heirline.nvim Configuration - Copilot Recommended Setup
# This configuration enables useful heirline features with sensible defaults
# Repository: https://github.com/rebelot/heirline.nvim
#
# Heirline is a highly customizable and fast statusline plugin for Neovim.
# This configuration provides a powerful statusline with smart path display,
# git integration, LSP status, and diagnostic information.
#
# Features enabled in this configuration:
# - Mode indicator with color coding
# - Smart file path display (abbreviates long paths intelligently)
# - Git branch and diff statistics
# - LSP server status and progress
# - Diagnostic counts with icons
# - File modification indicators
# - Search count display
# - Ruler (line:column numbers)
# - File type icons
# - Read-only file indicators
#
# Key differences from the template:
# - Focuses on practical, commonly used features
# - Includes the smart path abbreviation requested in PR #5
# - Optimized for performance with selective update events
# - Uses sensible color scheme integration
#
# To customize further, see heirline-template.nix for all available options

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
        local function setup_colors()
          return {
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
        end
        
        -- Smart path abbreviation (addresses PR #5 requirement)
        local function get_smart_file_path()
          local path = vim.fn.expand('%:p')
          if path == "" then
            return "[No Name]"
          end
          
          -- Get relative path from current working directory
          local cwd = vim.fn.getcwd()
          if path:sub(1, #cwd) == cwd then
            path = path:sub(#cwd + 2) -- Remove cwd and leading slash
          end
          
          -- Split path into parts
          local parts = {}
          for part in path:gmatch("[^/]+") do
            table.insert(parts, part)
          end
          
          -- If path is short, return as-is
          if #parts <= 2 then
            return parts[#parts] or ""
          end
          
          -- Create smart abbreviated path
          local result = {}
          for i = 1, #parts - 1 do
            if i == #parts - 1 then
              -- Keep the immediate parent directory full for context
              table.insert(result, parts[i])
            else
              -- Abbreviate other directories to first character
              table.insert(result, parts[i]:sub(1, 1))
            end
          end
          
          table.insert(result, parts[#parts]) -- Always show full filename
          
          local abbreviated = table.concat(result, "/")
          
          -- If still too long, just show parent/filename
          if #abbreviated > 40 then
            return parts[#parts - 1] .. "/" .. parts[#parts]
          end
          
          return abbreviated
        end
        
        -- Mode indicator component
        local mode_component = {
          init = function(self)
            self.mode = vim.fn.mode(1)
          end,
          static = {
            mode_names = {
              n = "NORMAL", no = "N-OP", nov = "N-OP", noV = "N-OP", ["no\22"] = "N-OP",
              niI = "N-INS", niR = "N-REP", niV = "N-VIS",
              nt = "N-TERM",
              v = "VISUAL", vs = "V-SEL", V = "V-LINE", Vs = "V-SEL", ["\22"] = "V-BLOCK", ["\22s"] = "V-SEL",
              s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK",
              i = "INSERT", ic = "INS-COMP", ix = "INS-COMP",
              R = "REPLACE", Rc = "REP-COMP", Rx = "REP-COMP", Rv = "V-REP", Rvc = "V-REP", Rvx = "V-REP",
              c = "COMMAND", cv = "EX", r = "PROMPT", rm = "MORE", ["r?"] = "CONFIRM", ["!"] = "SHELL",
              t = "TERMINAL",
            },
            mode_colors = {
              n = "blue", i = "green", v = "cyan", V = "cyan", ["\22"] = "cyan",
              c = "orange", s = "purple", S = "purple", ["\19"] = "purple",
              R = "orange", r = "orange", ["!"] = "red", t = "green",
            }
          },
          provider = function(self)
            return " " .. self.mode_names[self.mode] .. " "
          end,
          hl = function(self)
            local mode = self.mode:sub(1, 1)
            return { fg = "bright_bg", bg = self.mode_colors[mode], bold = true }
          end,
          update = { "ModeChanged", pattern = "*:*" },
        }
        
        -- File information component with smart path
        local file_info = {
          init = function(self)
            self.filename = vim.api.nvim_buf_get_name(0)
          end,
          -- File icon
          {
            init = function(self)
              local filename = vim.fn.fnamemodify(self.filename, ":t")
              local extension = vim.fn.fnamemodify(self.filename, ":e")
              self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
            end,
            provider = function(self)
              return self.icon and (self.icon .. " ")
            end,
            hl = function(self)
              return { fg = self.icon_color }
            end
          },
          -- Smart file path
          {
            provider = function(self)
              return get_smart_file_path()
            end,
            hl = { fg = "bright_fg", bold = true },
          },
          -- Modified indicator
          {
            condition = function()
              return vim.bo.modified
            end,
            provider = " ●",
            hl = { fg = "green" },
          },
          -- Readonly indicator
          {
            condition = function()
              return not vim.bo.modifiable or vim.bo.readonly
            end,
            provider = " ",
            hl = { fg = "orange" },
          },
        }
        
        -- Git status component
        local git_component = {
          condition = conditions.is_git_repo,
          init = function(self)
            self.status_dict = vim.b.gitsigns_status_dict
            self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
          end,
          -- Git branch
          {
            provider = function(self)
              return "  " .. self.status_dict.head .. " "
            end,
            hl = { fg = "orange", bold = true },
          },
          -- Git diff stats
          {
            condition = function(self)
              return self.has_changes
            end,
            {
              condition = function(self)
                return self.status_dict.added and self.status_dict.added > 0
              end,
              provider = function(self)
                return "+" .. self.status_dict.added .. " "
              end,
              hl = { fg = "git_add" },
            },
            {
              condition = function(self)
                return self.status_dict.changed and self.status_dict.changed > 0
              end,
              provider = function(self)
                return "~" .. self.status_dict.changed .. " "
              end,
              hl = { fg = "git_change" },
            },
            {
              condition = function(self)
                return self.status_dict.removed and self.status_dict.removed > 0
              end,
              provider = function(self)
                return "-" .. self.status_dict.removed .. " "
              end,
              hl = { fg = "git_del" },
            },
          },
        }
        
        -- LSP component
        local lsp_component = {
          condition = conditions.lsp_attached,
          update = {'LspAttach', 'LspDetach'},
          -- LSP server names
          {
            provider = function()
              local names = {}
              for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
                table.insert(names, server.name)
              end
              return " LSP[" .. table.concat(names, ",") .. "] "
            end,
            hl = { fg = "green" },
          },
        }
        
        -- Diagnostics component
        local diagnostics_component = {
          condition = conditions.has_diagnostics,
          static = {
            error_icon = " ",
            warn_icon = " ",
            info_icon = " ",
            hint_icon = " ",
          },
          init = function(self)
            self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
            self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
          end,
          update = { "DiagnosticChanged", "BufEnter" },
          {
            condition = function(self)
              return self.errors > 0
            end,
            provider = function(self)
              return self.error_icon .. self.errors .. " "
            end,
            hl = { fg = "diag_error" },
          },
          {
            condition = function(self)
              return self.warnings > 0
            end,
            provider = function(self)
              return self.warn_icon .. self.warnings .. " "
            end,
            hl = { fg = "diag_warn" },
          },
          {
            condition = function(self)
              return self.info > 0
            end,
            provider = function(self)
              return self.info_icon .. self.info .. " "
            end,
            hl = { fg = "diag_info" },
          },
          {
            condition = function(self)
              return self.hints > 0
            end,
            provider = function(self)
              return self.hint_icon .. self.hints .. " "
            end,
            hl = { fg = "diag_hint" },
          },
        }
        
        -- Search count component
        local search_component = {
          condition = function()
            return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
          end,
          init = function(self)
            local ok, search = pcall(vim.fn.searchcount)
            if ok and search.total then
              self.search = search
            end
          end,
          provider = function(self)
            local search = self.search
            return string.format(" [%d/%d] ", search.current, math.min(search.total, search.maxcount))
          end,
          hl = { fg = "cyan" },
        }
        
        -- Ruler component (line:column)
        local ruler_component = {
          provider = " %l:%c ",
          hl = { fg = "bright_fg" },
        }
        
        -- Percentage component
        local percentage_component = {
          provider = " %P ",
          hl = { fg = "bright_fg" },
        }
        
        -- Spacer component
        local spacer = { provider = "%=" }
        
        -- Assemble the statusline
        local statusline = {
          mode_component,
          file_info,
          git_component,
          spacer,
          search_component,
          lsp_component,
          diagnostics_component,
          ruler_component,
          percentage_component,
        }
        
        -- Setup heirline
        heirline.setup({
          statusline = statusline,
          opts = {
            colors = setup_colors(),
            disable_winbar_cb = function(args)
              return conditions.buffer_matches({
                buftype = { "nofile", "prompt", "help", "quickfix" },
                filetype = { "^git.*", "fugitive", "oil", "neo-tree", "aerial", "dapui" },
              }, args.buf)
            end,
          }
        })
        
        -- Update colors when colorscheme changes
        vim.api.nvim_create_augroup("Heirline", { clear = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            utils.on_colorscheme(setup_colors)
          end,
          group = "Heirline",
        })
      '';
    };
  };
}