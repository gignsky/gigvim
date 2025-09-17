{
  imports = [
    ./lang
    ./config
    ./plugins
    ./binds/core
    ./plugins/optional/mini.nix
  ];

  config.vim = {
    viAlias = true;
    vimAlias = true;
    enableLuaLoader = true;
  };
}
