_: {
  config.vim.autocomplete.blink-cmp = {
    enable = true;
    friendly-snippets.enable = true;
    setupOpts.completion.documentation.auto_show = true;
    mappings = {
      previous = "<C-p>";
      scrollDocsDown = "<C-d>";
      scrollDocsUp = "<C-u>";
    };
    setupOpts.fuzzy.implementation = "prefer_rust_with_warning";
    sourcePlugins = {
      emoji.enable = true;
      spell.enable = false;
    };
  };
}
