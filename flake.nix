{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      # # Optionally, you can also override individual plugins
      # # for example:
      # inputs.obsidian-nvim.follows = "obsidian-nvim"; # <- this will use the obsidian-nvim from your inputs
    };
    gigdot.url = "github:gignsky/dotfiles";
    home-manager.follows = "gigdot/home-manager";
    git-dev-nvim = {
      url = "github:moyiz/git-dev.nvim";
      flake = false;
    };
    snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      flake-parts,
      nvf,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { system, ... }:
        let
          overlays = import ./overlays.nix { inherit inputs; };
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ overlays.master-packages ];
          };
          minimalConfigModule = import ./minimal.nix;
          fullConfigModule = import ./full.nix { inherit inputs pkgs; };
          fullNvimConfig = nvf.lib.neovimConfiguration {
            modules = [ fullConfigModule ];
            inherit pkgs;
            extraSpecialArgs = { inherit inputs; };
          };
          minimalNvimConfig = nvf.lib.neovimConfiguration {
            modules = [ minimalConfigModule ];
            inherit pkgs;
            extraSpecialArgs = { inherit inputs; };
          };
        in
        {
          packages.minimal = minimalNvimConfig.neovim;
          packages.mini = minimalNvimConfig.neovim;
          packages.default = fullNvimConfig.neovim;
          packages.full = fullNvimConfig.neovim;
          packages.gigvim = fullNvimConfig.neovim;
          formatter = pkgs.nixfmt;
          devShells.default = pkgs.mkShell {
            packages = [
              fullNvimConfig.neovim
            ];
          };
        };

      flake = {
        homeManagerModules.default =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            options.programs.gigvim = {
              enable = lib.mkEnableOption "GigVim Neovim configuration";

              package = lib.mkOption {
                type = lib.types.package;
                description = "The Neovim package to use";
                default = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.full;
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

        # Custom modifications/overrides to upstream packages.
        overlays = import ./overlays.nix { inherit inputs; };
      };
    };
}
