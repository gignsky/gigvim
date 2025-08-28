# nvim-bacon Plugin Configuration for nvf
# allows for bacon integration in nvim

{ pkgs, ... }:
{
  imports = [ ../../themes ];
  config.vim = {
    extraPlugins = {
      bacon-nvim = {
        package = pkgs.vimPlugins.nvim-bacon;
        setup = ''
          require('bacon').setup({
            quickfix = {
              enabled = true, -- Enable Quickfix integration
              event_trigger = true, -- Trigger QuickFixCmdPost
            }
          })
        '';
      };
    };
  };
}
