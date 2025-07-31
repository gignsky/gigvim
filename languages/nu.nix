{pkgs, ...}: {
  config.vim.languages.nu = {
    enable = true;
    lsp = {
      enable = true;
    };
  };
}
