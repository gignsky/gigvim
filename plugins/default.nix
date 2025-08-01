{ lib, ... }:
{
  imports = [
    # ./mini.nix
    ./core
  ];

  config.vim = {
    telescope.enable = true;
    autocomplete.blink-cmp = {
      enable = true;
      setupOpts.completion.documentation.auto_show = true;
    };
    formatter.conform-nvim.enable = true;
    snippets.luasnip.enable = true;
    notes.todo-comments.enable = true;

    fzf-lua = {
      enable = true;
      profile = "default-title";
    };
  };
}
