{
  imports = [
    ./git-dev-nvim.nix
    ./themery-nvim.nix
    ./snacks-nvim.nix
  ];

  config.vim.keymaps = [
    {
      key = "jj";
      mode = "i";
      silent = true;
      action = "<Esc>";
    }
  ];
}
