{ pkgs, ... }:
{
  config.vim.languages.nix = {
    enable = true;
    format = {
      enable = true;
      type = [ "nixfmt" ]; # nixfmt-rfc-style, matches dotfiles pre-commit (gigvim#39 P0)
    };
    treesitter.enable = true;
  };

  # nixd over nil (gigvim#39). nixd links real Nix libexpr, so it *evaluates*:
  # real eval-error diagnostics, go-to-definition into nixpkgs source, and
  # evaluation-driven completion (packages + NixOS/HM options).
  #
  # The exprs use `builtins.getFlake (builtins.toString ./.)` so they follow the
  # opened project. `nixpkgs.expr` gives package completion everywhere; the
  # `options.*` exprs resolve only when editing a flake that actually HAS those
  # configs (the dotfiles) and silently no-op elsewhere — so they're safe to ship
  # in a general editor. Pointed at `ganoslal` as the representative host.
  config.vim.lsp.servers.nixd = {
    enable = true;
    package = pkgs.nixd;
    server = "nixd";
    options = {
      "nixd" = {
        "nixpkgs" = {
          "expr" = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";
        };
        "formatting" = {
          "command" = [ "${pkgs.nixfmt}/bin/nixfmt" ];
        };
        "options" = {
          "nixos" = {
            "expr" = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.ganoslal.options";
          };
          "home_manager" = {
            "expr" = "(builtins.getFlake (builtins.toString ./.)).homeConfigurations.\"gig@ganoslal\".options";
          };
        };
      };
    };
  };
}
