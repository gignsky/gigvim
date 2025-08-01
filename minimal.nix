{
  imports = [
    ./lang
    ./config
    ./plugins
  ];

  config.vim = {
    viAlias = true;
    vimAlias = true;
    enableLuaLoader = true;
  };
}
