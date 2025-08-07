{
  imports = [ ../../themes/gruvbox.nix ];
  config.vim = {
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };

    visuals = {
      nvim-web-devicons.enable = true;
      rainbow-delimiters.enable = true;
    };
  };
}
