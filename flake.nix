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
    gigdot.url = "github:gignsky/dotfiles";
    home-manager.follows = "gigdot/nixpkgs";
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

      perSystem = { pkgs, system, ... }:
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

      flake = {
        homeManagerModules.default = { config, lib, pkgs, ... }: {
          options.programs.gigvim = {
            enable = lib.mkEnableOption "GigVim Neovim configuration";
            
            package = lib.mkOption {
              type = lib.types.package;
              description = "The Neovim package to use";
              default = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.default;
            };
          };

          config = lib.mkIf config.programs.gigvim.enable {
            home.packages = [ config.programs.gigvim.package ];
            
            # Optional: Set as default editor
            home.sessionVariables = {
              EDITOR = lib.mkDefault "${config.programs.gigvim.package}/bin/nvim";
              VISUAL = lib.mkDefault "${config.programs.gigvim.package}/bin/nvim";
            };
          };
        };

        # Alias for convenience
        homeManagerModules.gigvim = inputs.self.homeManagerModules.default;
      };
    };
}
