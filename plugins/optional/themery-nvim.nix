{ inputs, pkgs, ... }:
let
  themery-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "themery-nvim";
    src = inputs.themery-nvim;
  };
in
{
  vim.extraPlugins = {
    themery = {
      package = themery-from-source;
      setup = ''
        require('themery').setup({
          themes = {
            "gruvbox",
            "ayu",
            "catppuccin",
            "catppuccin-latte",
            "catppuccin-frappe", 
            "catppuccin-macchiato",
            "catppuccin-mocha",
            "tokyonight",
            "tokyonight-night",
            "tokyonight-storm",
            "tokyonight-day",
            "tokyonight-moon",
            "nord",
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
            "darkplus",
            "github_dark",
            "github_light",
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
            "space-vim-dark",
            "oceanic-next",
            "tender",
            "base16-default-dark",
            "base16-default-light",
            "base16-mocha",
            "base16-ocean",
            "base16-tomorrow",
            "base16-eighties",
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
            "zellner"
          };
        })
      '';
    };
  };
}
