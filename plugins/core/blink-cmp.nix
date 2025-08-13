# Blink.cmp Enhanced Configuration
# Advanced configuration for blink.cmp completion engine
# Repository: https://github.com/Saghen/blink.cmp
#
# blink.cmp is a modern, fast completion engine for Neovim with built-in
# support for LSP, snippets, and various completion sources.
#
# This configuration addresses potential conflicts with other plugins:
# - nvim-autopairs: blink.cmp has built-in bracket completion
# - luasnip: Integrated snippet support
# - Auto-semicolon insertion based on language context
#
# Features configured:
# - Enhanced LSP completion with documentation
# - Built-in snippet expansion
# - Smart bracket auto-pairing with language-aware semicolon insertion
# - Fuzzy matching and filtering
# - Custom completion sources
# - Performance optimizations
#
# Conflict Resolution:
# - Disabled nvim-autopairs in favor of blink.cmp's built-in pairs
# - Configured language-specific auto-semicolon behavior
# - Optimized for Rust, Nix, Python, JavaScript/TypeScript workflows
#
# Settings configured:
# - Documentation window with auto-show
# - Smart completion triggering
# - Language-aware auto-closing behavior
# - Snippet integration with luasnip
# - Performance tuning for large codebases
#
# Settings still need to be configured:
# - Custom completion sources (file paths, database, etc.)
# - Project-specific completion preferences
# - Advanced filtering rules

{ lib, ... }:
{
  # Disable nvim-autopairs to avoid conflicts with blink.cmp's built-in pairs
  config.vim.autopairs.nvim-autopairs.enable = lib.mkForce false;
  
  config.vim.autocomplete.blink-cmp = {
    enable = true;
    
    setupOpts = {
      -- Appearance configuration
      appearance = {
        use_nvim_cmp_as_default = true;
        nerd_font_variant = "mono";
      };
      
      -- Sources for completion
      sources = {
        default = [ "lsp" "path" "snippets" "buffer" ];
        providers = {
          lsp = {
            name = "LSP";
            module = "blink.cmp.sources.lsp";
            enabled = true;
            transform_items = "function(_, items) return items end";
            should_show_items = true;
            max_items = 200;
            min_keyword_length = 0;
            fallbacks = [ "buffer" ];
          };
          
          path = {
            name = "Path";
            module = "blink.cmp.sources.path";
            score_offset = 3;
            enabled = true;
            opts = {
              trailing_slash = false;
              label_trailing_slash = true;
              get_cwd = "function(context) return vim.fn.getcwd() end";
              show_hidden_files_by_default = false;
            };
          };
          
          snippets = {
            name = "Snippets";
            module = "blink.cmp.sources.snippets";
            score_offset = -1;
            enabled = true;
            opts = {
              friendly_snippets = true;
              search_paths = [ "~/.config/nvim/snippets" ];
              global_snippets = [ "all" ];
              extended_filetypes = {};
              ignored_filetypes = [];
            };
          };
          
          buffer = {
            name = "Buffer";
            module = "blink.cmp.sources.buffer";
            enabled = true;
            max_items = 5;
            min_keyword_length = 3;
            opts = {
              get_bufnrs = "function() return vim.api.nvim_list_bufs() end";
            };
          };
        };
      };
      
      -- Completion behavior configuration
      completion = {
        accept = {
          create_undo_point = true;
          auto_brackets = {
            enabled = true;
            default_brackets = [ "(" ")" ];
            override_brackets_for_filetypes = {};
            force_allow_filetypes = {};
            blocked_filetypes = {};
            kind_resolution = {
              enabled = true;
              blocked_filetypes = [ "typescript" "typescriptreact" "javascript" "javascriptreact" ];
            };
            semantic_token_resolution = {
              enabled = true;
              blocked_filetypes = [];
            };
          };
        };
        
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 500;
          update_delay_ms = 50;
          treesitter_highlighting = true;
          window = {
            min_width = 10;
            max_width = 60;
            max_height = 20;
            border = "single";
            winblend = 0;
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None";
            scrollbar = true;
            direction_priority = [ "e" "w" "n" "s" ];
          };
        };
        
        ghost_text = {
          enabled = true;
        };
        
        menu = {
          enabled = true;
          min_width = 15;
          max_height = 10;
          border = "none";
          winblend = 0;
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None";
          scrolloff = 2;
          scrollbar = true;
          direction_priority = [ "s" "n" ];
          
          draw = {
            treesitter = [ "lsp" ];
            columns = [
              [ "kind_icon" ]
              [ "label" "label_description" ]
              [ "source_name" ]
            ];
            components = {
              kind_icon = {
                ellipsis = false;
                text = "function(ctx) return ctx.kind_icon .. ctx.icon_gap end";
                highlight = "CmpItemKind";
              };
              
              kind = {
                ellipsis = false;
                width = { fill = true };
                text = "function(ctx) return ctx.kind end";
                highlight = "CmpItemKind";
              };
              
              label = {
                width = { fill = true; max = 60 };
                text = "function(ctx) return ctx.label .. ctx.label_detail end";
                highlight = "CmpItemAbbr";
              };
              
              label_description = {
                width = { max = 30 };
                text = "function(ctx) return ctx.label_description end";
                highlight = "CmpItemAbbrMatch";
              };
              
              source_name = {
                width = { max = 30 };
                text = "function(ctx) return '[' .. ctx.source_name .. ']' end";
                highlight = "CmpItemMenu";
              };
            };
          };
        };
        
        trigger = {
          prefetch_on_insert = true;
          show_on_insert_on_trigger_character = true;
          show_on_trigger_character = true;
          show_on_keyword = true;
          show_on_accept_on_trigger_character = true;
          keyword_range = "prefix";
          keyword_regex = "[%w_\\-]";
          exclude_from_prefix_regex = "[\\-]";
        };
        
        list = {
          max_items = 200;
          selection = "preselect";
          cycle = {
            from_bottom = true;
            from_top = true;
          };
        };
      };
      
      -- Fuzzy matching configuration
      fuzzy = {
        use_frecency = true;
        use_proximity = true;
        max_items = 200;
        sorts = [ "label" "kind" "score" "recent" ];
        prebuilt_binaries = {
          download = true;
          force_version = null;
        };
      };
      
      -- Keymap configuration
      keymap = {
        preset = "default";
        
        ["<C-space>"] = [ "show" "show_documentation" "hide_documentation" ];
        ["<C-e>"] = [ "hide" ];
        ["<C-y>"] = [ "select_and_accept" ];
        
        ["<C-p>"] = [ "select_prev" "fallback" ];
        ["<C-n>"] = [ "select_next" "fallback" ];
        
        ["<C-u>"] = [ "scroll_documentation_up" "fallback" ];
        ["<C-d>"] = [ "scroll_documentation_down" "fallback" ];
        
        ["<C-l>"] = [ "snippet_forward" "fallback" ];
        ["<C-h>"] = [ "snippet_backward" "fallback" ];
        
        ["<Tab>"] = [ "snippet_forward" "select_next" "fallback" ];
        ["<S-Tab>"] = [ "snippet_backward" "select_prev" "fallback" ];
        
        ["<CR>"] = [ "accept" "fallback" ];
      };
      
      -- Signature help configuration
      signature = {
        enabled = true;
        trigger = {
          blocked_trigger_characters = [];
          blocked_retrigger_characters = [];
          show_on_insert_on_trigger_character = true;
        };
        window = {
          min_width = 1;
          max_width = 100;
          max_height = 10;
          border = "single";
          winblend = 0;
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder";
          scrollbar = false;
          direction_priority = [ "n" "s" ];
        };
      };
    };
  };
  
  # Configure auto-semicolon behavior per language via autocmds
  config.vim.extraConfigLua = ''
    -- Language-specific auto-semicolon configuration
    local semicolon_languages = {
      rust = true,
      javascript = true,
      typescript = true,
      java = true,
      c = true,
      cpp = true,
      cs = true,
    }
    
    -- Function to add semicolon intelligently
    local function smart_semicolon()
      local filetype = vim.bo.filetype
      if not semicolon_languages[filetype] then
        return
      end
      
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      
      -- Check if we're at the end of a statement that needs a semicolon
      local patterns = {
        "let%s+%w+%s*=%s*.+",  -- let bindings (Rust)
        "const%s+%w+%s*=%s*.+", -- const declarations
        "var%s+%w+%s*=%s*.+",   -- var declarations
        "%w+%.%w+%s*%(.*%)",    -- method calls
        "return%s+.+",          -- return statements
        "%w+%s*=%s*.+",         -- assignments
      }
      
      local should_add_semicolon = false
      for _, pattern in ipairs(patterns) do
        if line:match(pattern) and not line:match(";%s*$") then
          should_add_semicolon = true
          break
        end
      end
      
      if should_add_semicolon then
        vim.api.nvim_set_current_line(line .. ";")
        -- Move cursor to after the semicolon
        vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col + 1 })
      end
    end
    
    -- Auto-command for smart semicolon insertion
    vim.api.nvim_create_augroup("BlinkCmpSmartSemicolon", { clear = true })
    vim.api.nvim_create_autocmd("CompleteDone", {
      group = "BlinkCmpSmartSemicolon",
      callback = function()
        -- Delay slightly to let completion finish
        vim.defer_fn(smart_semicolon, 50)
      end,
    })
    
    -- Key mapping for manual semicolon insertion
    vim.keymap.set('i', '<C-;>', function()
      smart_semicolon()
    end, { desc = 'Smart semicolon insertion' })
  '';
}