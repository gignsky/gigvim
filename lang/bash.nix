{ pkgs, ... }:
{
  config.vim.languages.bash = {
    enable = true;
    extraDiagnostics = {
      enable = true;
      types = [ "shellcheck" ];
    };
    format.enable = true;
    lsp.enable = true;
    treesitter.enable = true;
  };
}
