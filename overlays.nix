#
# Overlays layered onto gigpkgs.legacyPackages for gigvim.
#
# Currently a no-op — all packages come straight from gigpkgs. Leave the
# scaffolding here so future overlays can be dropped in without rewiring
# flake.nix. To activate: uncomment the desired overlay(s) and the matching
# `.extend` call in flake.nix's `pkgsFor`.
#
{ inputs, ... }:
{
  # # Expose bleeding-edge nixpkgs (master) as `pkgs.master.*`.
  # # Sourced from gigpkgs' own nixpkgs-master input.
  # master-packages = final: prev: {
  #   master = import inputs.gigpkgs.inputs.nixpkgs-master {
  #     inherit (prev) system;
  #     config.allowUnfree = true;
  #     overlays = [ ];
  #   };
  # };
}
