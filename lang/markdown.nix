{pkgs, ...}: {
  config.vim.languages.markdown = {
    enable = true;
    format = {
      enable = true;
      type = "prettier";
      package = pkgs.nodePackages.prettier;
    };
    lsp = {
      enable = true;
      package = pkgs.marksman;
      server = "marksman";
    };
    treesitter.enable = true;
  };

  config.vim.lsp.servers.marksman = {
    enable = true;
  };

  config.vim.snippets.luasnip = {
    enable = true;
    providers = [
      "markdown"
      pkgs.marksman
    ];
  };
}