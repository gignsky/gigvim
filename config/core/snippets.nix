# Snippet configuration
# Extracted from lang/default.nix to make it configurable
{
  config.vim.snippets.luasnip = {
    enable = true;
    providers = [
      "nvim-lspconfig"
      "nvim-treesitter"
    ];
  };
}