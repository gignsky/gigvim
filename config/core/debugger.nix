# Debugging configuration
# Extracted from lang/default.nix to make it configurable
{
  config.vim.debugger.nvim-dap = {
    enable = false;
    ui = {
      enable = true;
      autoStart = true;
    };
  };
}