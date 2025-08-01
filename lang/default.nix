{ pkgs, ... }:
{
  imports = [
    # ./bash.nix
    # ./css.nix
    # ./html.nix
    # ./lua.nix
    # ./markdown.nix
    ./nix.nix
    ./nu.nix
    # ./python.nix
    # ./rust.nix
    # ./sql.nix
    # ./svelte.nix
    # ./tailwind.nix
    # ./typescript.nix
    # ./typst.nix
  ];

  config.vim = {
    lsp = {
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

    debugger.nvim-dap = {
      enable = false;
      ui = {
        enable = true;
        autoStart = true;
      };
    };

    treesitter = {
      enable = true;
      addDefaultGrammars = true;
      autotagHtml = true;
      grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    };

    languages = {
      enableFormat = false;
      enableTreesitter = true;
      enableExtraDiagnostics = false;
      enableDAP = false;
    };
  };
}
