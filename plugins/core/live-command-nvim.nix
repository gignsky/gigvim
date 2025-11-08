# live-command.nvim - Preview commands in Neovim
# Provides live preview for arbitrary Ex commands including :g!, :s, and more
# https://github.com/smjonas/live-command.nvim

{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    live-command-nvim = {
      package = pkgs.vimPlugins.live-command-nvim;
      setup = ''
        require("live-command").setup {
          commands = {
            Norm = { cmd = "norm" },
          },
        }
      '';
    };
  };
}
