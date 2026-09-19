_: {
  config.vim = {
    languages.markdown = {
      enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
      # TODO Create plugin that live switches between these two, might be as simple as an extra keybind
      extensions = {
        markview-nvim.enable = true;
        render-markdown-nvim.enable = false;
      };
    };

    # `deno fmt` defaults to --prose-wrap=always, which is worse than tex-fmt's
    # wrapping: as well as breaking lines at 80 columns it *joins* lines the
    # author broke by hand, so a paragraph written one clause per line comes
    # back as a single reflowed block. "preserve" leaves prose line breaks
    # exactly as written while still tidying tables, lists and code fences.
    #
    # This must be append_args rather than prepend_args: conform's built-in
    # deno_fmt args are ["fmt" "-" "--ext" "md"], and the flag has to come after
    # the subcommand.
    formatter.conform-nvim.setupOpts.formatters."deno_fmt".append_args = [ "--prose-wrap=preserve" ];
  };
}
