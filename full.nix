{
  inputs,
  pkgs,
  ...
}:
let
  # Import the git-dev module with inputs passed through
  gitDevModule = import ./plugins/optional/git-dev-nvim.nix { inherit inputs pkgs; };
  snacksModule = import ./plugins/optional/snacks-nvim.nix { inherit inputs pkgs; };
  # themeryModule = import ./plugins/optional/themery-nvim.nix { inherit inputs pkgs; };
in
{
  imports = [
    ./minimal.nix
    gitDevModule
    snacksModule
    # themeryModule
  ];
}
