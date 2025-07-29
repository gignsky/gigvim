{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      # # Optionally, you can also override individual plugins
      # # for example:
      # inputs.obsidian-nvim.follows = "obsidian-nvim"; # <- this will use the obsidian-nvim from your inputs
    };
  };

  outputs =
    { flake-parts
    , nvf
    , ...
    } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem = { pkgs, ... }:
        let
          configModule = import ./nvf-config.nix;
          nvimConfig = nvf.lib.neovimConfiguration {
            modules = [ configModule ];
            inherit pkgs;
          };
        in
        {
          packages.default = nvimConfig.neovim;
          formatter = pkgs.alejandra;
        };
    };
}
