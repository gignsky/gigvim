{
  inputs,
  pkgs,
  ...
}:
let
  # Import the git-dev module with inputs passed through
  gigvimModule = import ./gigvim.nix { inherit inputs pkgs; };
in
{
  imports = [
    gigvimModule
    ./plugins/optional/themery-nvim.nix
  ];
}
