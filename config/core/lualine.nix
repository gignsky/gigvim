# Lualine Configuration for Minimal GigVim
# This file provides lualine statusline configuration for the minimal version
# The full version uses heirline instead of lualine for more advanced features
{ lib, ... }:
{
  config.vim.statusline.lualine = {
    enable = true;
    theme = "gruvbox";
    # Simplified configuration for minimal version
    # For advanced statusline features, use the full version with heirline
  };
}