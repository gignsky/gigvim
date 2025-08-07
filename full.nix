{ inputs, pkgs, ... }:
let
  # Import the themery module with inputs passed through
  themeryModule = import ./plugins/optional/themery-nvim.nix { inherit inputs pkgs; };
in
{
  imports = [
    ./minimal.nix
    themeryModule
  ];
}
