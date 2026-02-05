{ inputs, pkgs, ... }:
let
  snacksModule = import ../plugins/optional/snacks-nvim.nix { inherit inputs pkgs; };
in
{
  imports = [
    snacksModule
    ../binds/module/snacks-nvim.nix
  ];
}
