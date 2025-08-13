# Otter Configuration for Embedded Language Support
# Provides otter-nvim functionality for embedded languages

{ pkgs, ... }:
{
  config.vim = {
    # Enable otter-nvim for embedded language support
    lsp.otter-nvim.enable = true;
  };
}
