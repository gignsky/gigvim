{ inputs, pkgs, ... }:
let
  modWithInputs = plug: (import plug { inherit inputs pkgs; });

  gitDev = modWithInputs ./gitDevModule.nix;
  snacks = modWithInputs ./snacksModule.nix;
  themery = modWithInputs ./themeryModule.nix;
in
{
  imports = [
    gitDev
    snacks
    themery
  ];
}
