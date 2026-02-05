{
  inputs,
  pkgs,
  ...
}:
let
  # Import the git-dev module with inputs passed through
  fullModules = import ./vim-modules { inherit inputs pkgs; };
in
{
  imports = [
    ./minimal.nix
    fullModules
    ./plugins/optional/commasemi-nvim.nix
    ./config/optional/notes.nix
    ./config/optional/diagnostics.nix
    ./binds/optional/folding.nix
  ];
}
