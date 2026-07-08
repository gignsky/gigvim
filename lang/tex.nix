_: {
  config.vim.languages.tex = {
    enable = true;
    # Formatter: nvf defaults to tex-fmt; latexindent is also available.
    format = {
      enable = true;
      type = [ "tex-fmt" ];
    };
    lsp = {
      enable = true;
      server = "texlab";
    };
    treesitter.enable = true;
  };
}
