{
  config.vim.options = {
    number = true;
    linebreak = true;
    showbreak = "+++";
    textwidth = 100;
    showmatch = true;
    spell = false;
    errorbells = true;

    hlsearch = true;
    smartcase = true;
    gdefault = true;
    ignorecase = true;
    incsearch = true;
    inccommand = "split"; #Adds splitting ability for complex find and replace with exclusions

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
