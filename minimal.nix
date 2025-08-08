{
  imports = [
    ./lang
    ./config
    ./plugins
    ./binds
    ./plugins/optional/mini.nix
    ./config/core/lualine.nix  # Use lualine for minimal version
  ];

  config.vim = {
    viAlias = true;
    vimAlias = true;
    enableLuaLoader = true;
  };
}
