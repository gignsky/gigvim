{ lib, ... }:
{
  imports = [
    # ./mini.nix
    ./core
  ];

  config.vim = {
    telescope.enable = true;
    formatter.conform-nvim.enable = true;
    snippets.luasnip.enable = true;

    fzf-lua = {
      enable = true;
      profile = "default-title";
    };
  };
}
