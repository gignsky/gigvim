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

      # Expose a variant's nvim under its own command name (e.g. `mark`) so it
      # can be installed alongside the main gigvim without bin/nvim, vi, vim
      # collisions.
      renameBin =
        sys: name: bin: pkg:
        (pkgsFor sys).runCommand "gigvim-${name}" { meta.mainProgram = bin; } ''
          mkdir -p $out/bin
          ln -s ${pkg}/bin/nvim $out/bin/${bin}
        '';
    in
    {
      packages = forAllSystems (
        sys:
        let
          pkgs = pkgsFor sys;
          fullModule = import ./full.nix { inherit inputs pkgs; };
          full = mkNvim sys "full" fullModule;
          minimal = mkNvim sys "mini" (import ./minimal.nix);
          marker = mkNvim sys "marker" (import ./marker.nix);
          differ = mkNvim sys "differ" (import ./differ.nix);
        in
        {
          # Same config as full; only the version label differs.
          default = mkNvim sys null fullModule;
          full = full;
          # gigvim = full;
          minimal = minimal;
          mini = minimal;
          marker = marker;
          differ = differ;

          # Variants with renamed binaries (`mark`, `differ`) for side-by-side installs
          gigvim-marker = renameBin sys "marker" "mark" marker;
          gigvim-differ = renameBin sys "differ" "differ" differ;
        }
      );

      overlays.default =
        final: _prev:
        let
          p = self.packages.${final.stdenv.hostPlatform.system};
        in
        {
          gigvim = p.full;
          gigvim-marker = p.gigvim-marker;
          gigvim-differ = p.gigvim-differ;
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

      homeModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          cfg = config.programs.gigvim;
          p = self.packages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          options.programs.gigvim = {
            enable = lib.mkEnableOption "GigVim Neovim configuration";

            package = lib.mkOption {
              type = lib.types.package;
              description = "The Neovim package to use";
              default = p.full;
            };

            # Variants install as their own commands and work with or without `enable`
            marker = {
              enable = lib.mkEnableOption "the GigVim marker (prose/markdown) variant as `mark`";
              package = lib.mkOption {
                type = lib.types.package;
                description = "Package providing the `mark` command";
                default = p.gigvim-marker;
              };
            };

            differ = {
              enable = lib.mkEnableOption "the GigVim differ variant as `differ`";
              package = lib.mkOption {
                type = lib.types.package;
                description = "Package providing the `differ` command";
                default = p.gigvim-differ;
              };
              gitTool = lib.mkEnableOption "differ as git's diff.tool and merge.tool";
            };
          };

          config = lib.mkMerge [
            (lib.mkIf cfg.enable {
              home.packages = [ cfg.package ];

              home.sessionVariables = {
                EDITOR = lib.mkDefault "${cfg.package}/bin/nvim";
                VISUAL = lib.mkDefault "${cfg.package}/bin/nvim";
              };
            })

            (lib.mkIf cfg.marker.enable {
              home.packages = [ cfg.marker.package ];
            })

            (lib.mkIf cfg.differ.enable {
              home.packages = [ cfg.differ.package ];
            })

            (lib.mkIf (cfg.differ.enable && cfg.differ.gitTool) {
              programs.git.settings =
                let
                  differ = lib.getExe cfg.differ.package;
                in
                {
                  diff.tool = "differ";
                  difftool.prompt = false;
                  difftool.differ.cmd = ''${differ} -d "$LOCAL" "$REMOTE"'';
                  merge.tool = "differ";
                  mergetool.differ.cmd = ''${differ} -d "$LOCAL" "$REMOTE" "$MERGED" -c "wincmd J"'';
                };
            })
          ];
        };

      homeModules.gigvim = self.homeModules.default;
    };
}
