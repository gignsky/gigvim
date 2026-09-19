_: {
  config.vim = {
    languages.tex = {
      enable = true;
      format = {
        enable = true;
        type = [ "tex-fmt" ];
      };
      lsp.enable = true;
      treesitter.enable = true;
    };

    # tex-fmt wraps at 80 columns by default, so format-on-save reflowed the
    # whole document on every write -- breaking around macros and braces rather
    # than at anything meaningful in the prose. "--nowrap" keeps the useful half
    # (indentation and whitespace normalisation) and leaves line breaks where
    # the author put them: tex-fmt only ever splits over-long lines and never
    # joins lines, so with wrapping off it cannot move a break at all.
    #
    # nvf's tex module sets only `command` on this formatter, so this merges
    # rather than conflicts. conform's built-in tex-fmt entry supplies "-s",
    # giving `tex-fmt --nowrap -s`.
    formatter.conform-nvim.setupOpts.formatters."tex-fmt".prepend_args = [ "--nowrap" ];
  };
}
