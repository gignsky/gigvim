# Manual Test File for Embedded Language Support
# This file contains examples of the patterns we want to support
#
# New features in this PR:
# 1. Context-aware commenting: Use 'gc' in normal/visual mode
#    - Lua code gets '--' comments
#    - Bash code gets '#' comments  
#    - Nix code gets '#' comments
# 2. Inline evaluation: Use '<leader>le' to evaluate code
#    - Lua: Direct execution with error reporting
#    - Bash: Shellcheck validation
# 3. Enhanced language detection with generic patterns

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
        -- This should be highlighted as Lua with generic detection
        require('test').setup({
          option = "value",
          nested = {
            key = true,
            number = 42
          }
        })
        
        -- Test function definitions
        local function myFunc()
          print("Hello from embedded Lua!")
        end
        
        -- Test vim API calls
        vim.keymap.set('n', '<leader>t', function()
          print("Hello from embedded Lua!")
        end)
      '';
    };
  };
  
  # Test case 2: More generic Lua patterns
  someConfig = ''
    local config = {
      enabled = true,
      options = {}
    }
    
    function setup()
      vim.notify("Setup complete")
    end
  '';
  
  # Test case 3: Bash in writeShellScriptBin
  test-script = pkgs.writeShellScriptBin "test-script" ''
    #!/bin/bash
    # This should be highlighted as Bash
    echo "Testing embedded bash support"
    
    if [ -d "$HOME" ]; then
      echo "Home directory exists"
      tree --version 2>/dev/null || echo "tree not available"
    fi
    
    # Test variable expansion and loops
    for file in *.nix; do
      echo "Processing $file"
    done
  '';
  
  # Test case 4: More generic bash patterns
  otherScript = ''
    echo "Generic bash detection test"
    
    if [ "$1" = "test" ]; then
      echo "Test mode"
    fi
    
    for i in {1..5}; do
      echo "Iteration $i"
    done
  '';
  
  # Test case 6: Mixed languages in configuration
  complexConfig = ''
    # Lua configuration
    require('plugin').setup({
      option = true,
      callback = function()
        vim.notify("Plugin loaded")
      end
    })
    
    # Followed by some bash
    echo "Setting up environment"
    export PATH="$PATH:/custom/bin"
  '';
}