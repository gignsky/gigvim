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
                   notify = true, -- Show notification when big file detected
                   size = 1.5 * 1024 * 1024, -- 1.5MB threshold
                   line_length = 1000, -- Average line length for minified files
                   -- Custom setup function to disable performance-heavy features
                   setup = function(ctx)
                     -- Disable parentheses matching
                     if vim.fn.exists(":NoMatchParen") ~= 0 then
                       vim.cmd([[NoMatchParen]])
                     pcall(vim.cmd, 'NoMatchParen')
                     
                     -- Set window options for better performance
                     require('snacks').util.wo(ctx.win, { 
                       foldmethod = "manual", 
                       statuscolumn = "", 
                       conceallevel = 0 
                     })
                     
                     -- Disable mini.animate if present
                     vim.b.minianimate_disable = true
                     
                     -- Disable snacks animations for this buffer by setting disable flags
                     vim.b.snacks_animate_disable = true
                     vim.b.snacks_indent_animate_disable = true
                     vim.b.snacks_dim_animate_disable = true
                     vim.b.snacks_scroll_animate_disable = true
                     vim.b.snacks_scope_animate_disable = true
                     
                     -- Disable indent guides for large files
                     vim.b.snacks_indent = false
                     
                     -- Disable word highlighting 
                     vim.b.snacks_words = false
                     
                     -- Disable scope highlighting
                     vim.b.snacks_scope = false
                     
                     -- Disable snacks features that rely on treesitter/LSP
                     vim.b.snacks_statuscolumn = false
                     
                     -- Disable terminal and other heavy features  
                     vim.b.snacks_terminal = false
                     
                     -- Disable LSP for this buffer (bigfile optimization)
                     -- Note: nvf doesn't support lazy loading like lazy.nvim, but we can disable LSP
                     vim.b.semantic_tokens_enabled = false
                     vim.schedule(function()
                       if vim.api.nvim_buf_is_valid(ctx.buf) then
                         -- Detach LSP clients if any are attached
                         for _, client in pairs(vim.lsp.get_active_clients({ bufnr = ctx.buf })) do
                           vim.lsp.buf_detach_client(ctx.buf, client.id)
                         end
                         -- Disable LSP auto-attach for this buffer
                         -- Removed custom flag; rely on standard LSP detachment
                       end
                     end)
                     
                     -- Set basic syntax highlighting (fallback)
                     vim.schedule(function()
                       if vim.api.nvim_buf_is_valid(ctx.buf) then
                         vim.bo[ctx.buf].syntax = ctx.ft
                       end
                     end)
                     
                     -- Show notification that bigfile optimization is active
                     if require('snacks').notifier then
                     local ok, notifier = pcall(function() return require('snacks').notifier end),
                     if ok and notifier and type(notifier.notify) == "function" then
                       notifier.notify("Bigfile detected - Performance optimizations active", {
                         level = "info", 
                         title = "GigVim BigFile",
                         timeout = 3000
                       })
                     end
                   end,
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
                   theme = {
                     activeBorderColor = { "#a6da95", "bold" },
                     inactiveBorderColor = { "#494d64" },
                     optionsTextColor = { "#8bd5ca" },
                     selectedLineBgColor = { "#363a4f" },
                     selectedRangeBgColor = { "#363a4f" },
                     cherryPickedCommitBgColor = { "#494d64" },
                     cherryPickedCommitFgColor = { "#a6da95" },
                     unstagedChangesColor = { "#ed8796" },
                     defaultFgColor = { "#cad3f5" },
                   },
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
                   left = { "mark", "sign" },
                   right = { "fold", "git" },
                   folds = {
                     open = true,
                     git_hl = true,
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
                    height = 0.8,
                    width = 0.8,
                  },
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
    tectonic # tectonic - required for LaTeX support
    git # its git bitch
    # latex     # pdflatex - required for LaTeX support
    # mmdc         # mmdc - required for Markdown support
  ];
}
