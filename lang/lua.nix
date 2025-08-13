{ pkgs, ... }:
{
  config.vim.languages.lua = {
    enable = true;
    extraDiagnostics = {
      enable = true;
      types = [ "luacheck" ];
    };
    format.enable = true;
    lsp.enable = true;
    # lsp.lazydev.enable = true;
    treesitter.enable = true;
  };
}
