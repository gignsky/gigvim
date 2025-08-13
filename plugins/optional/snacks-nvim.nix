# Template for adding external (non-packaged) plugins to nvf
#
# To use this template:
# 1. Add the plugin source to flake.nix inputs:
#    ```nix
#    your-plugin = {
#      url = "github:user/plugin.nvim";
#      flake = false;
#    };
#    ```
# 2. Copy this file and modify it for your plugin
# 3. Import it in full.nix or minimal.nix as needed
# 4. Ensure the importing module has access to inputs parameter
#
# NOTE: This template requires inputs to be available in the module context.
# The safest approach is to inline the plugin configuration in full.nix
# as demonstrated with themery-nvim.

{ inputs, pkgs, ... }:
let
  snacks-nvim-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "snacks-nvim";
    src = inputs.snacks-nvim; # Must match the input name in flake.nix
  };
in
{
  config.vim.extraPlugins = {
    snacks-nvim = {
      package = snacks-nvim-from-source;
      setup = ''
        require('your-plugin').setup({
          -- Your plugin configuration here
        })
      '';
    };
  };
}

