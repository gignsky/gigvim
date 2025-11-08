# traces.vim - Range, pattern and substitute preview for Vim
# Provides live preview for :substitute, :global, and other Ex commands
# https://github.com/markonm/traces.vim

{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    traces-vim = {
      package = pkgs.vimPlugins.traces-vim;
    };
  };
}
