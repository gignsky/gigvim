{
  imports = [
    ./otter.nix
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
