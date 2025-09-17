{
  inputs,
  pkgs,
  ...
}:
let
  # Import the git-dev module with inputs passed through
  gitDevModule = import ./plugins/optional/git-dev-nvim.nix { inherit inputs pkgs; };
  snacksModule = import ./plugins/optional/snacks-nvim.nix { inherit inputs pkgs; };
in
{
  imports = [
    ./minimal.nix
    gitDevModule
    snacksModule
    ./plugins/optional/commasemi-nvim.nix
    ./config/optional/notes.nix
    ./config/optional/diagnostics.nix
    ./binds/optional/folding.nix
  ];
}
