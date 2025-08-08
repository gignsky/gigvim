{ inputs, pkgs, ... }:
let
  snacksModule = import ./plugins/optional/snacks-nvim.nix { inherit inputs pkgs; };
  # Import the themery module with inputs passed through
  themeryModule = import ./plugins/optional/themery-nvim.nix { inherit inputs pkgs; };
in
{
  imports = [
    ./minimal.nix
    # themeryModule
    snacksModule
  ];
}
