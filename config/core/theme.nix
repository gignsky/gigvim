# Theme-independent visuals shared by every build.
#
# The ACTIVE colorscheme (+ style) now lives in the flavor (flavors/*.nix,
# composed by mkGigvim in flake.nix), so the look travels with the flavor rather
# than the base config — see gigvim#40. Colorscheme plugins are pulled in by the
# flavor that selects them.
{
  config.vim.visuals = {
    nvim-web-devicons.enable = true;
    rainbow-delimiters.enable = true;
  };
}
