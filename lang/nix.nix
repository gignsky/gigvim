{pkgs, ...}: {
  config.vim.languages.nix = {
    enable = true;
    format = {
      type = "alejandra";
      package = pkgs.alejandra;
    };
    lsp = {
      enable = true;
      package = pkgs.nil;
      server = "nil";
    };
    treesitter.enable = true;
  };
}
