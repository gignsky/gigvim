{ pkgs, ... }:
{
  config.vim.languages.markdown = {
    enable = true;
    format.enable = true;
    lsp.enable = true;
    treesitter.enable = true;
    extensions = {
      markview-nvim.enable = true;
      render-markdown-nvim.enable = true;
    };
  };

}
