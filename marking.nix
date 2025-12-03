{ pkgs, lib, ... }:
{
  imports = [
    ./lang/markdown.nix
    ./config
    ./plugins
    ./binds
    ./plugins/optional/mini.nix
  ];

  config.vim = {
    theme = {
      name = lib.mkForce "slate";
    };
    keymaps = [
      {
        key = "jj";
        mode = "i";
        silent = true;
        action = "<Esc>";
      }
      {
        key = "<leader>w";
        mode = "n";
        silent = false;
        action = "<C-w>";
        desc = "Window Mode";
      }
      {
        key = "<leader>td";
        mode = "n";
        action = "";
        silent = true;
        desc = "+Todo Options";
      }
    ];
    lsp = {
      enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      lspkind.enable = true;
      null-ls.enable = true;
      nvim-docs-view.enable = true;
      lightbulb.enable = false;
      trouble.enable = true;
      otter-nvim.enable = false;
    };
    treesitter = {
      enable = true;
      addDefaultGrammars = true;
      autotagHtml = true;
      grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    };
    snippets.luasnip = {
      enable = true;
      providers = [
        "nvim-lspconfig"
        "nvim-treesitter"
      ];
    };
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = false;
      enableDAP = false;
    };
    viAlias = true;
    vimAlias = true;
    enableLuaLoader = true;
  };
}
