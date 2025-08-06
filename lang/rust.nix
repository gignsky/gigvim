{pkgs, ...}: {
  config.vim.languages.rust = {
    enable = true;
    crates = {
      enable = true;
      codeActions = true;
    };
    dap.enable = true;
    format = {
      enable = true;
      type = "rustfmt";
    };
    lsp = {
      enable = true;
    };
    treesitter.enable = true;
  };
}
