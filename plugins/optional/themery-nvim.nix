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
              "gruvbox",
              "tokyonight",
              "nord"
            },
            livePreview = true
          })
        '';
      };
    };
  };
}
