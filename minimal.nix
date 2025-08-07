{
  imports = [
    ./lang
    ./config
    ./plugins
    ./binds
    ./plugins/optional/mini.nix
  ];

  config.vim = {
    viAlias = true;
    vimAlias = true;
    enableLuaLoader = true;
  };
}
