{
  imports = [
    ./lang
    ./config
  ];

  config.vim = {
    viAlias = true;
    vimAlias = true;
    enableLuaLoader = true;
  };
}
