{
  imports = [
    ./git-dev-nvim.nix
    ./themery-nvim.nix
    ./snacks-nvim.nix
    ./optional
  ];

  config.vim.keymaps = [
    {
      key = "jj";
      mode = "i";
      silent = true;
      action = "<Esc>";
    }
    {
      key = "<leader>w";
      mode = "n";
      silent = false;
      action = "<C-w>";
      desc = "Window Mode";
    }
    {
      key = "<leader>td";
      mode = "n";
      action = "";
      silent = true;
      desc = "+Todo Options";
    }
  ];
}
