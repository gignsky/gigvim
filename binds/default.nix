{
  imports = [
    ./git-dev-nvim.nix
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
