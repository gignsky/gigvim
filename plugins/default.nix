{ lib, ... }:
{
  imports = [
    # ./mini.nix
    ./core
  ];

  config.vim = {
    telescope.enable = true;
    # blink-cmp configuration moved to ./core/blink-cmp.nix for better organization
    formatter.conform-nvim.enable = true;
    snippets.luasnip.enable = true;
    notes.todo-comments.enable = true;

    fzf-lua = {
      enable = true;
      profile = "default-title";
    };
  };
}
