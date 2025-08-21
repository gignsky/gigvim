_: {
  config.vim.languages.markdown = {
    enable = true;
    format.enable = true;
    lsp.enable = true;
    treesitter.enable = true;
    # TODO Create plugin that live switches between these two, might be as simple as an extra keybind
    extensions = {
      markview-nvim.enable = true;
      render-markdown-nvim.enable = false;
    };
  };
}
