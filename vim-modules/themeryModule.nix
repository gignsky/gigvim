{inputs, pkgs,...}:
let
  themery = import ../plugins/optional/themery-nvim.nix { inherit inputs pkgs; };
in  
{
  imports = [
    themery
    ../binds/module/themery-nvim.nix
  ]
}
