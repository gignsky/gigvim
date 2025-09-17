{ lib, ... }:
{
  imports = [
    ./git-dev-nvim.nix
  ];

  config.vim.keymaps = lib.mkDefault [
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
    {
      key = "<leader>t";
      mode = "n";
      action = "";
      desc = "+Todo";
    }
  ];
}
