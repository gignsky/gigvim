{
  config.vim.options = {
    number = true;
    linebreak = true;
    showbreak = "+++";
    textwidth = 100;

    # Neovim's default is "tcqj"; this is that, less "t". The "t" flag
    # auto-wraps text at 'textwidth' as you type, so an edit in the middle of a
    # paragraph can silently insert a hard line break. Folding long lines is
    # left to 'wrap'/'linebreak', which change the display without touching the
    # file, and to "gq" when a reflow is deliberately asked for.
    # "c" (auto-wrap comments) is kept for code; config/core/prose.nix drops
    # that one too in prose buffers.
    formatoptions = "cqj";

    showmatch = true;
    spell = false;
    errorbells = true;

    hlsearch = true;
    smartcase = true;
    gdefault = true;
    ignorecase = true;
    incsearch = true;

    autoindent = true;
    expandtab = true;
    shiftwidth = 2;
    smartindent = true;
    smarttab = true;
    softtabstop = 2;

    ruler = true;

    undolevels = 1000;
    backspace = "indent,eol,start";
  };
}
