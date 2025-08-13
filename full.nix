{ inputs, pkgs, ... }:
let
  # Import the themery module with inputs passed through
  themeryModule = import ./plugins/optional/themery-nvim.nix { inherit inputs pkgs; };
  # Import the git-dev module with inputs passed through
  gitDevModule = import ./plugins/optional/git-dev-nvim.nix { inherit inputs pkgs; };
  # Import the copilot module with inputs passed through
  copilotModule = import ./plugins/optional/copilot.nix { inherit inputs pkgs; };
in
{
  imports = [
    ./minimal.nix
    copilotModule
    themeryModule
    gitDevModule
  ];
}
