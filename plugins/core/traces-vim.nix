# traces.vim - Range, pattern and substitute preview for Vim
# Provides live preview for :substitute, :global, and other Ex commands
# https://github.com/markonm/traces.vim
#
# Note: This plugin automatically disables inccommand internally to avoid conflicts.
# Do not set inccommand when using traces.vim, as they cannot work together.

{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    traces-vim = {
      package = pkgs.vimPlugins.traces-vim;
    };
  };
}
