_: {
  config.vim = {
    languages.css = {
      enable = true;
      lsp = {
        enable = true;
      };
      format.enable = true;
      treesitter.enable = true;
    };
    ui.colorizer.setupOpts.filetypes."css" = {
      css_fn = true;
      css = true;
    };
  };
}
