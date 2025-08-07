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
              "catppuccin-mocha"
            },
            livePreview = true
          })
        '';
      };
      
      -- Add gruvbox theme package
      gruvbox = {
        package = pkgs.vimPlugins.gruvbox-nvim;
      };
      
      -- Add tokyonight theme package  
      tokyonight = {
        package = pkgs.vimPlugins.tokyonight-nvim;
      };
      
      -- Add nord theme package
      nord = {
        package = pkgs.vimPlugins.nord-nvim;
      };
    };
  };
}
