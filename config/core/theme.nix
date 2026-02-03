{
  imports = [
    ../../themes/gruvbox.nix
    ../../themes/catppuccin.nix
  ];
  config.vim = {
    theme = {
      enable = true;
      # name = "gruvbox";
      # style = "dark";
      name = "catppuccin";
      style = "mocha";
    };
    visuals = {
      nvim-web-devicons.enable = true;
      rainbow-delimiters.enable = true;
    };
  };
}
