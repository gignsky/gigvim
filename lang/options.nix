# Language Configuration Options
# This file provides configurable language support options for GigVim
#
# This allows users to selectively enable language support when including
# GigVim in their devShell or flake configurations.
#
# Usage example in a flake:
# ```nix
# {
#   inputs.gigvim.url = "github:gignsky/gigvim";
#
#   devShells.default = pkgs.mkShell {
#     packages = [
#       (inputs.gigvim.packages.${system}.configurable {
#         languages = {
#           rust = true;
#           nix = true;
#           python = false;  # Disable python for this project
#         };
#       })
#     ];
#   };
# }
# ```

{ lib, ... }:
{
  options = {
    gigvim = {
      languages = {
        bash = lib.mkEnableOption "Bash language support" // {
          default = true;
        };
        nix = lib.mkEnableOption "Nix language support" // {
          default = true;
        };
        nu = lib.mkEnableOption "Nu shell language support" // {
          default = true;
        };
        python = lib.mkEnableOption "Python language support" // {
          default = false;
        };
        rust = lib.mkEnableOption "Rust language support" // {
          default = true;
        };
        sql = lib.mkEnableOption "SQL language support" // {
          default = false;
        };
        toml = lib.mkEnableOption "TOML language support" // {
          default = true;
        };
        yaml = lib.mkEnableOption "YAML language support" // {
          default = true;
        };
        lean = lib.mkEnableOption "Lean theorem prover support" // {
          default = false;
        };

        # Additional languages (commented for now)
        # css = lib.mkEnableOption "CSS language support" // { default = false; };
        # html = lib.mkEnableOption "HTML language support" // { default = false; };
        # javascript = lib.mkEnableOption "JavaScript language support" // { default = false; };
        # typescript = lib.mkEnableOption "TypeScript language support" // { default = false; };
        # lua = lib.mkEnableOption "Lua language support" // { default = false; };
        # markdown = lib.mkEnableOption "Markdown language support" // { default = false; };
        # sql = lib.mkEnableOption "SQL language support" // { default = false; };
      };
    };
  };
}

