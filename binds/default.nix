{
  imports = [
    ./otter.nix
    ./git-dev-nvim.nix
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
