# Themery.nvim Plugin Configuration for nvf
# Theme switcher plugin for Neovim

{ outputs, pkgs, ... }:
let
  pkgs' = import pkgs.path {
    inherit (pkgs) system;
    overlays = [ outputs.overlays.unstable-packages ];
  };
in
{
  imports = [ ../../themes ];
  config.vim = {
    extraPlugins = {
      themery = {
        package = pkgs'.unstable.vimPlugins.themery-nvim;
        setup = ''
          require('themery').setup({
            themes = {
              -- Built-in vim themes (always available)
              "default",
              "blue", 
              "darkblue",
              "delek",
              "desert",
              "elflord",
              "evening",
              "industry",
              "koehler",
              "morning",
              "murphy",
              "pablo",
              "peachpuff",
              "ron",
              "shine",
              "slate",
              "torte",
              "zellner",
              -- Catppuccin variants (configured in themes/)
              "catppuccin",
              "catppuccin-latte",
              "catppuccin-frappe", 
              "catppuccin-macchiato",
              "catppuccin-mocha",
              -- Other themes
              "ayu",
              "onedark",
              "dracula",
              "material",
              "palenight",
              "nightfox",
              "duskfox",
              "nordfox", 
              "terafox",
              "carbonfox",
              "kanagawa",
              "kanagawa-wave",
              "kanagawa-dragon",
              "kanagawa-lotus",
              "rose-pine",
              "rose-pine-main",
              "rose-pine-moon",
              "rose-pine-dawn",
              "monokai-pro",
              "solarized",
              "everforest",
              "sonokai",
              "edge",
              "tender",
              "gruvbox",
              "tokyonight",
              "tokyonight-night",
              "tokyonight-storm",
              "tokyonight-day",
              "tokyonight-moon",
              "nord"
            },
            livePreview = true
          })
        '';
      };
    };
  };
}
