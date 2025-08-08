# Language Server Protocol (LSP) configuration
# Extracted from lang/default.nix to make it configurable
{
  config.vim.lsp = {
    enable = true;
    formatOnSave = true;
    inlayHints.enable = true;
    lspkind.enable = true;
    null-ls.enable = true;
    nvim-docs-view.enable = true;
    lightbulb.enable = true;
    trouble.enable = true;
    otter-nvim.enable = true;
  };
}