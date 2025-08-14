#
# This file defines overlays/custom modifications to upstream packages
#

{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  # additions = final: _prev: import ../pkgs { pkgs = final; };

  # # This one contains whatever you want to overlay
  # # You can change versions, add patches, set compilation flags, anything really.
  # # https://wiki.nixos.org/wiki/Overlays
  # modifications = final: prev: {
  #   # example = prev.example.overrideAttrs (oldAttrs: let ... in {
  #   # ...
  #   # });
  # };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.master'
  master-packages = final: _prev: {
    master = import inputs.nixpkgs-master {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  # be accessible through 'pkgs.local'
  local-packages = final: _prev: {
    local = import inputs.nixpkgs-local {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
