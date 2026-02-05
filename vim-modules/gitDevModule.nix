{inputs, pkgs,...}:
let
  gitDev = import ../plugins/optional/git-dev-nvim.nix { inherit inputs pkgs; };
in  
{
  imports = [
    gitDev
    ../binds/module/git-dev-nvim.nix
  ]
}
