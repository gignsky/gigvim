# Themery.nvim Plugin Configuration for nvf
# Theme switcher plugin for Neovim

{ inputs, pkgs, ... }:
let
  themery-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "themery-nvim";
    src = inputs.themery-nvim;
  };
in
{
  imports = [ ../../themes ];
  config.vim = {
    extraPlugins = {
      themery = {
        package = themery-from-source;
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
              "onelight",
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
              "monokai",
              "monokai-pro",
              "solarized",
              "solarized8",
              "everforest",
              "sonokai",
              "edge",
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
