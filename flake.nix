{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-tectonic.url = "github:NixOS/nixpkgs/c3fc1fe6d8765d99c8614c6f82d611dc56b9ae37";
    # nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    # nixpkgs-local.url = "git+file:///home/gig/local_repos/nixpkgs";
    # nixpkgs-local.url = "github:gignsky/nixpkgs/gignsky/add-commasemi-nvim";
    flake-parts.follows = "nvf/flake-parts";
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
            overlays = [
              overlays.master-packages
              overlays.local-packages
              overlays.tectonic-packages
            ];
          };
          minimalConfigModule = import ./minimal.nix;
          fullConfigModule = import ./full.nix { inherit inputs pkgs; };
          gigvimConfigModule = import ./gigvim.nix { inherit inputs pkgs; };
          fullNvimConfig = nvf.lib.neovimConfiguration {
            modules = [ fullConfigModule ];
            inherit pkgs;
            extraSpecialArgs = { inherit inputs; };
          };
          gigvimConfig = nvf.lib.neovimConfiguration {
            modules = [ gigvimConfigModule ];
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
          # --------------- PACKAGES -----------------
          # --------------- MINI -----------------
          packages.minimal = minimalNvimConfig.neovim;
          packages.mini = minimalNvimConfig.neovim;
          # ------------- GIGVIM ---------------
          packages.default = gigvimConfig.neovim;
          packages.gigvim = gigvimConfig.neovim;
          # ----------- FULL ----------------
          packages.full = fullNvimConfig.neovim;
          packages.max = fullNvimConfig.neovim;
          # ---------------------------------

          formatter = pkgs.nixfmt;
          devShells.gigvim = pkgs.mkShell {
            packages = [
              gigvimConfig.neovim
            ];
          };
          devShells.mini = pkgs.mkShell {
            packages = [
              minimalNvimConfig.neovim
            ];
          };
          devShells.full = pkgs.mkShell {
            packages = [
              fullNvimConfig.neovim
            ];
          };
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
