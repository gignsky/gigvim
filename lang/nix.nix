{pkgs, ...}: {
  config.vim.languages.nix = {
    enable = true;
    format = {
      enable = true;
      type = "nixfmt";
      package = pkgs.nixfmt-rfc-style;
    };
    lsp = {
      enable = true;
      package = pkgs.nil;
      server = "nil";
    };
    treesitter.enable = true;
  };

  config.vim.lsp.servers.nil = {
    settings.nixos-options = {
      expr = "builtins.getFlake(toString ./.);";
    };
    enable = true;
  };

  config.vim.snippets.luasnip = {
    enable = true;
    providers = [
      "nix-develop-nvim"
      pkgs.nil
    ];
  };
}
