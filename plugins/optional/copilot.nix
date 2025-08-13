# https://github.com/CopilotC-Nvim/CopilotChat.nvim
{ pkgs, ... }:
{
  config.vim = {
    assistant.copilot = {
      enable = true;
      setupOpts = {
        panel.layout.position = "right";
      };
    };
    extraPlugins.copilotChat = {
      package = pkgs.vimPlugins.CopilotChat-nvim;
      setup = ''
        require('copilotChat')
      '';
    };
  };
}
