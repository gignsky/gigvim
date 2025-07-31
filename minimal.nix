{
  imports = [
    ./lang
    ./config/minimal.nix
    ./plugins/minimal.nix
  ];

  config.vim = {
    viAlias = true;
    vimAlias = true;
    enableLuaLoader = true;
  };
}
