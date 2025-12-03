{ lib, ... }:
{
  imports = [
    ./lang
    ./config
    ./plugins
    ./binds
    ./plugins/optional/mini.nix
  ];

  config.vim = {
    theme = {
      name = lib.mkForce "nord";
    };
    viAlias = true;
    vimAlias = true;
    enableLuaLoader = true;
  };
}
