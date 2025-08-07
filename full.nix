{ inputs, pkgs, ... }:
let
  # Import the themery module with inputs passed through
  themeryModule = import ./plugins/optional/themery-nvim.nix { inherit inputs pkgs; };
  # Import the nvim-bacon module with inputs passed through
  nvimBaconModule = import ./plugins/optional/nvim-bacon.nix { inherit inputs pkgs; };
  # Import the beepboop module with inputs passed through
  beepboopModule = import ./plugins/optional/beepboop-nvim.nix { inherit inputs pkgs; };
in
{
  imports = [
    ./minimal.nix
    themeryModule
    nvimBaconModule
    beepboopModule
  ];
}
