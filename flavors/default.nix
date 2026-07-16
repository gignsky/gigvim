# The `default` gigvim flavor — the reference visual identity.
#
# A flavor carries the whole look: the active colorscheme (+ style) and, as the
# flavor set grows, its dashboard art, statusline accents, and purpose plugins.
# Flavors are applied at EVERY tier (gigvim#40: tier scales capability, never
# beauty), so `minimal` + `default` is exactly as pretty as `full` + `default`.
{ ... }:
{
  imports = [
    ../themes/catppuccin.nix # the colorscheme plugin
  ];
  config.vim.theme = {
    enable = true;
    name = "catppuccin";
    style = "mocha";
  };
}
