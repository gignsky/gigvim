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
    flake-parts.follows = "nvf/flake-parts";

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

      mkNvim =
        sys: module:
        (nvf.lib.neovimConfiguration {
          pkgs = pkgsFor sys;
          modules = [ module ];
          extraSpecialArgs = { inherit inputs; };
        }).neovim;
    in
    {
      packages = forAllSystems (
        sys:
        let
          pkgs = pkgsFor sys;

          # Capability TIERS — plugin/LSP depth only. Tiers never touch the look.
          tiers = {
            full = import ./full.nix { inherit inputs pkgs; };
            minimal = import ./minimal.nix;
          };

          # FLAVORS — the full visual identity (active colorscheme + style, and
          # as the set grows: dashboard art, statusline accents, purpose plugins).
          # A flavor is applied at EVERY tier, so a small tier is just as
          # beautiful as a big one (gigvim#40: tier must not diminish flavor).
          flavors = {
            default = import ./flavors/default.nix;
          };

          # tier x flavor -> a neovim. Beauty (flavor) is orthogonal to size (tier).
          mkGigvim =
            {
              tier ? tiers.full,
              flavor ? flavors.default,
            }:
            mkNvim sys { imports = [ tier flavor ]; };
        in
        {
          # default / full / gigvim were three identical aliases — now one build,
          # full tier + the default flavor.
          default = mkGigvim { };
          full = mkGigvim { };
          gigvim = mkGigvim { };
          # minimal tier, SAME default flavor — proof that tier ⊥ flavor.
          minimal = mkGigvim { tier = tiers.minimal; };
          mini = mkGigvim { tier = tiers.minimal; };
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
