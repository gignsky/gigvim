{
  imports = [
    ./lang
    ./config
    ./plugins
    ./binds
  ];

  config.vim = {
    viAlias = true;
    vimAlias = true;
    enableLuaLoader = true;
  };
}
