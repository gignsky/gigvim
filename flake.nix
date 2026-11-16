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

      mkNvim =
        sys: module:
        (nvf.lib.neovimConfiguration {
          pkgs = pkgsFor sys;
          modules = [ module ];
          extraSpecialArgs = { inherit inputs; };
        }).neovim;

      # Expose a variant's nvim under its own command name (e.g. `marking`) so it
      # can be installed alongside the main gigvim without bin/nvim, vi, vim
      # collisions.
      renameBin =
        sys: name: pkg:
        (pkgsFor sys).runCommand "gigvim-${name}" { meta.mainProgram = name; } ''
          mkdir -p $out/bin
          ln -s ${pkg}/bin/nvim $out/bin/${name}
        '';
    in
    {
      packages = forAllSystems (
        sys:
        let
          pkgs = pkgsFor sys;
          full = mkNvim sys (import ./full.nix { inherit inputs pkgs; });
          minimal = mkNvim sys (import ./minimal.nix);
          marking = mkNvim sys (import ./marking.nix);
          differ = mkNvim sys (import ./differ.nix);
        in
        {
          default = full;
          full = full;
          # gigvim = full;
          minimal = minimal;
          mini = minimal;
          marking = marking;
          differ = differ;

          # Variants with renamed binaries (`marking`, `differ`) for side-by-side installs
          gigvim-marking = renameBin sys "marking" marking;
          gigvim-differ = renameBin sys "differ" differ;
        }
      );

      overlays.default =
        final: _prev:
        let
          p = self.packages.${final.stdenv.hostPlatform.system};
        in
        {
          gigvim = p.full;
          gigvim-marking = p.gigvim-marking;
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

      homeManagerModules.default =
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
            marking = {
              enable = lib.mkEnableOption "the GigVim marking (prose/markdown) variant as `marking`";
              package = lib.mkOption {
                type = lib.types.package;
                description = "Package providing the `marking` command";
                default = p.gigvim-marking;
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

            (lib.mkIf cfg.marking.enable {
              home.packages = [ cfg.marking.package ];
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

      homeManagerModules.gigvim = self.homeManagerModules.default;
    };
}
