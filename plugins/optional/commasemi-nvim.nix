# commasemi.nvim Plugin Configuration for nvf
# allows for easy placement of commas and semi-colons

{ pkgs, ... }:
{
  imports = [ ../../themes ];
  config.vim = {
    extraPlugins = {
      commasemi = {
        package = pkgs.vimPlugins.commasemi-nvim;
        setup = ''
          require('commasemi').setup({
            lazy = false,
            opts = {
              leader = "<localleader>",
              keymaps = true,
              commands = true,
            }
          })
        '';
      };
    };
  };
}
