{pkgs, ...}: {
  config.vim.languages.rust = {
    enable = true;
    crates = {
      enable = true;
      codeActions = true;
    };
    # dap.enable = false;
    format = {
      enable = true;
      type = "rustfmt";
    };
    lsp = {
      enable = true;
      package = pkgs.rust-analyzer;
      opts = ''
        ['rust-analyzer'] = {
            cargo = {allFeature = true},
            checkOnSave = true,
            procMacro = {
              enable = true,
            },
          },
      '';
    };
    treesitter.enable = true;
  };
}
