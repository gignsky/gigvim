{
  description = "gigvim — Gig's Neovim configuration";

  inputs = {
    nixpkgs.url = "github:gignsky/gigpkgs/gigpkgs-unstable";
    # nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    # nixpkgs-local.url = "git+file:///home/gig/local_repos/nixpkgs";
    # nixpkgs-local.url = "github:gignsky/nixpkgs/gignsky/add-commasemi-nvim";
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.follows = "nixpkgs/home-manager";

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
      nixpkgs,
      nvf,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Bring gigpkgs in as our nixpkgs. To layer local overlays, uncomment
      # entries in ./overlays.nix and chain them here, e.g.:
      #   let overlays = import ./overlays.nix { inherit inputs; }; in
      #   sys: (inputs.gigpkgs.legacyPackages.${sys}).extend overlays.master-packages
      pkgsFor = sys: inputs.nixpkgs.legacyPackages.${sys};

      # Single source of truth for the version; roll-flow bumps it.
      version = (builtins.fromJSON (builtins.readFile ./package.json)).version;

      # `distro` is the label suffix: null for the default package,
      # "full"/"mini" for the named ones (v0.1.0, v0.1.0-full, v0.1.0-mini).
      mkNvim =
        sys: distro: module:
        (nvf.lib.neovimConfiguration {
          pkgs = pkgsFor sys;
          modules = [
            module
            (import ./version.nix { inherit version distro; })
          ];
          extraSpecialArgs = { inherit inputs; };
        }).neovim;
    in
    {
      packages = forAllSystems (
        sys:
        let
          pkgs = pkgsFor sys;
          fullModule = import ./full.nix { inherit inputs pkgs; };
          full = mkNvim sys "full" fullModule;
          minimal = mkNvim sys "mini" (import ./minimal.nix);
        in
        {
          # Same config as full; only the version label differs.
          default = mkNvim sys null fullModule;
          full = full;
          # gigvim = full;
          minimal = minimal;
          mini = minimal;
        }
      );

      overlays.default = final: _prev: {
        gigvim = self.packages.${final.stdenv.hostPlatform.system}.full;
      };

      formatter = forAllSystems (sys: (pkgsFor sys).nixfmt);

      devShells = forAllSystems (
        sys:
        let
          pkgs = pkgsFor sys;
        in
        {
          default = pkgs.mkShell {
            packages = [
              self.packages.${sys}.full
              pkgs.locker
            ];
          };
        }
      );

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
              default = self.packages.${pkgs.stdenv.hostPlatform.system}.full;
            };
          };

          config = lib.mkIf config.programs.gigvim.enable {
            home.packages = [ config.programs.gigvim.package ];

            home.sessionVariables = {
              EDITOR = lib.mkDefault "${config.programs.gigvim.package}/bin/nvim";
              VISUAL = lib.mkDefault "${config.programs.gigvim.package}/bin/nvim";
            };
          };
        };

      homeManagerModules.gigvim = self.homeManagerModules.default;
    };
}
