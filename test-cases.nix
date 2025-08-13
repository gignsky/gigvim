# Manual Test File for Embedded Language Support
# This file contains examples of the patterns we want to support

{ inputs, pkgs, ... }:
let
  test-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "test-plugin";
    src = pkgs.writeText "test-plugin" "";
  };
in
{
  # Test case 1: Lua in extraPlugins setup
  config.vim.extraPlugins = {
    test-setup = {
      package = test-plugin;
      setup = ''
        require('test').setup({
          -- This should be highlighted as Lua
          option = "value",
          nested = {
            key = true,
            number = 42
          }
        })
        
        -- Test function call
        vim.keymap.set('n', '<leader>t', function()
          print("Hello from embedded Lua!")
        end)
      '';
    };
  };
  
  # Test case 2: Bash in writeShellScriptBin (example pattern)
  # Note: This would typically be in a packages.nix or similar file
}

# Separate test for writeShellScriptBin pattern
# (This represents the pattern from the dotfiles repo)
rec {
  test-script = pkgs.writeShellScriptBin "test-script" ''
    #!/bin/bash
    # This should be highlighted as Bash
    echo "Testing embedded bash support"
    
    if [ -d "$HOME" ]; then
      echo "Home directory exists"
      ${pkgs.tree}/bin/tree --version
    fi
    
    # Test variable expansion
    for file in *.nix; do
      echo "Processing $file"
    done
  '';
}