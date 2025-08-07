{
  imports = [
    ./options.nix
    ./brackets.nix
    # ./line.nix  # Removed - handled separately in minimal vs full
    ./theme.nix
    ./lsp.nix
    ./debugger.nix
    ./treesitter.nix
    ./snippets.nix
    ./languages.nix
  ];
}
