{ lib, ... }:
{
  imports = [
    ./lang
    ./config
    ./plugins
    ./binds
    ./plugins/optional/mini.nix
    ./themes/kanagawa.nix
  ];

  config.vim = {
    theme = {
      name = lib.mkForce "kanagawa";
      style = lib.mkForce "lotus";
    };
    viAlias = true;
    vimAlias = true;
    enableLuaLoader = true;
  };
}
