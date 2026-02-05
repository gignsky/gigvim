{ inputs, pkgs, ... }:
let
  modWithInputs = plug: (import plug { inherit inputs pkgs; });

  gitDev = modWithInputs ./gitDevModule.nix;
  snacks = modWithInputs ./snacksModule.nix;
  themery = modWithInputs ./themeryModule.nix;
  spectre = modWithInputs ./spectreModule.nix;
in
{
  imports = [
    gitDev
    snacks
    themery
    spectre
  ];
}
