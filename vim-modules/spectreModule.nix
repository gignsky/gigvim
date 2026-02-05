{ inputs, pkgs, ... }:
let
  spectre = import ../plugins/optional/nvim-spectre.nix { inherit inputs pkgs; };
in
{
  imports = [
    spectre
    # ../binds/module/nvim-spectre.nix
  ];
}
