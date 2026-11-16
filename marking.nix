{ pkgs, lib, ... }:
{
  imports = [
    ./lang/markdown.nix
    ./config
    ./plugins
    ./binds
    ./plugins/optional/mini.nix
    ./themes/kanagawa.nix # Enable kanagawa theme plugin
  ];

  config.vim = {
    # Add minimal themery for your preferred themes only
    extraPlugins = {
      themery = {
        package = pkgs.vimPlugins.themery-nvim;
        setup = ''
          require('themery').setup({
            themes = {
              "slate",           -- Built-in vim theme (your preference)
              "kanagawa",        -- Kanagawa theme
              "kanagawa-lotus",  -- Kanagawa lotus variant
            },
            livePreview = true
          })
        '';
      };
    };

    # "slate" is a built-in vim colorscheme, not an nvf theme, so disable nvf's
    # theme module and apply it directly. It runs before themery's setup
    # (extraPluginConfigs) so a theme picked in themery still wins.
    theme.enable = lib.mkForce false;
    luaConfigRC.marking-colorscheme =
      lib.nvim.dag.entryBetween
        [ "extraPluginConfigs" ]
        [
          "pluginConfigs"
        ]
        "vim.cmd.colorscheme('slate')";
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
