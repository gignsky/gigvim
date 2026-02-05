# commasemi.nvim Plugin Configuration for nvf
# allows for easy placement of commas and semi-colons

{ pkgs, ... }:
{
  config.vim = {
    extraPlugins = {
      nvim-spectre = {
        package = pkgs.vimPlugins.nvim-spectre;
        setup = ''
          require('spectre').setup({
          })
        '';
      };
    };
  };
}
# lazy = false,
# opts = {
#   leader = "<localleader>",
#   keymaps = true,
#   commands = true,
# }
