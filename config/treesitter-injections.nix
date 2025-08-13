# Treesitter injection configuration for embedded languages
# Provides better syntax highlighting for embedded code in Nix files

{ pkgs, ... }:
{
  config.vim = {
    # Ensure required treesitter parsers are available
    extraPackages = with pkgs; [
      tree-sitter-grammars.tree-sitter-nix
      tree-sitter-grammars.tree-sitter-lua
      tree-sitter-grammars.tree-sitter-bash
    ];
  };
}