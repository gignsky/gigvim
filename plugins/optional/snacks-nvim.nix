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
                     easing = "linear",  -- Available: linear, ease, easeIn, easeOut, easeInOut, circIn, circOut, circInOut, backIn, backOut, backInOut, bounceOut
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
                   fps = 60,
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
                 
                 -- New snacks plugins
                 scope = { enabled = true },
                 scroll = { enabled = true },
                 statuscolumn = { enabled = true },
                 words = { enabled = true },
                 
                 -- Terminal and image support
                 terminal = { enabled = true },
                 image = { enabled = false }, -- disabled since wsl2 doesn't support it
               })
               
               -- Set up vim.ui.input to use snacks after setup
               vim.ui.input = require('snacks').input
      '';
    };
  };

  # Required dependencies for snacks.nvim functionality
  config.vim.extraPackages = with pkgs; [
    ripgrep      # rg - required for grep functionality
    fd           # fd - required for file finding (v8.4+)
    sqlite       # sqlite3 - required for certain snacks features
    gscan2pdf      # gs - required for image support
    tectonic     # tectonic - required for LaTeX support
    # latex     # pdflatex - required for LaTeX support
    # mmdc         # mmdc - required for Markdown support
  ];
}
