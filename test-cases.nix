# Comprehensive Test File for Embedded Language Support
# This file contains enhanced examples of the patterns we support
#
# Enhanced features in this configuration:
# 1. Automatic otter-nvim activation for .nix files with embedded code
# 2. Smart content detection for Lua and Bash patterns
# 3. Treesitter injection queries for better syntax highlighting
# 4. Enhanced keybindings: <leader>lo/ld/lr/lf/li/le/lL
# 5. Full LSP integration with embedded languages

{ inputs, pkgs, ... }:
let
  test-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "test-plugin";
    src = pkgs.writeText "test-plugin" "";
  };
in
{
  # Test case 1: Enhanced Lua in extraPlugins setup (should auto-activate)
  config.vim.extraPlugins = {
    test-setup = {
      package = test-plugin;
      setup = ''
        -- This should be automatically detected as Lua code
        require('test').setup({
          option = "value",
          nested = {
            key = true,
            number = 42,
            callback = function(opts)
              return opts.enabled and "active" or "inactive"
            end
          }
        })
        
        -- Test advanced Lua features
        local function createKeybinding(key, action, desc)
          vim.keymap.set('n', key, action, { 
            desc = desc,
            silent = true,
            noremap = true 
          })
        end
        
        -- Test vim API calls (should trigger detection)
        vim.keymap.set('n', '<leader>tt', function()
          local status = require('test').get_status()
          vim.notify("Plugin status: " .. vim.inspect(status))
        end, { desc = 'Test embedded lua functionality' })
        
        -- Test conditionals and loops
        for _, mode in ipairs({'n', 'v', 'i'}) do
          vim.keymap.set(mode, '<C-t>', '<cmd>TestCommand<cr>')
        end
        
        if vim.fn.exists(':TestCommand') == 0 then
          vim.api.nvim_create_user_command('TestCommand', function()
            print("Test command executed from embedded Lua!")
          end, {})
        end
      '';
    };
  };
  
  # Test case 2: Complex Lua configuration (should auto-activate)
  luaConfig = ''
    local M = {}
    
    -- Complex configuration object
    M.config = {
      enabled = true,
      features = {
        lsp = true,
        treesitter = true,
        completion = true
      },
      keymaps = {
        ['<leader>lg'] = ':lua require("test").goto_definition()<CR>',
        ['<leader>lh'] = ':lua require("test").hover()<CR>',
      }
    }
    
    -- Function with error handling
    function M.setup(opts)
      opts = opts or {}
      M.config = vim.tbl_deep_extend('force', M.config, opts)
      
      -- Setup keymaps
      for key, action in pairs(M.config.keymaps) do
        vim.keymap.set('n', key, action, { desc = 'Test keymap' })
      end
      
      -- Error handling
      local ok, result = pcall(function()
        return require('some-plugin').initialize(M.config)
      end)
      
      if not ok then
        vim.notify('Failed to initialize: ' .. result, vim.log.levels.ERROR)
      end
      
      return M
    end
    
    return M
  '';
  
  # Test case 3: Enhanced Bash in writeShellScriptBin (should auto-activate)
  test-script = pkgs.writeShellScriptBin "test-script" ''
    #!/bin/bash
    set -euo pipefail  # Best practices
    
    # This should be automatically detected as Bash code
    echo "Testing enhanced embedded bash support"
    
    # Function definitions
    check_dependencies() {
      local deps=("git" "curl" "jq")
      for dep in "''${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
          echo "Missing dependency: $dep" >&2
          return 1
        fi
      done
    }
    
    # Complex conditionals
    if [ -d "$HOME/.config" ]; then
      echo "Config directory exists"
      config_files=$(find "$HOME/.config" -name "*.conf" -type f | wc -l)
      echo "Found $config_files configuration files"
    else
      echo "Creating config directory"
      mkdir -p "$HOME/.config"
    fi
    
    # Array handling
    declare -a nix_files
    while IFS= read -r -d $'\0' file; do
      nix_files+=("$file")
    done < <(find . -name "*.nix" -print0)
    
    echo "Processing ''${#nix_files[@]} Nix files:"
    for file in "''${nix_files[@]}"; do
      echo "  - Processing: $file"
      lines=$(wc -l < "$file")
      echo "    Lines: $lines"
    done
    
    # Command substitution and pipes
    current_time=$(date +"%Y-%m-%d %H:%M:%S")
    git_status=$(git status --porcelain 2>/dev/null | wc -l)
    echo "[$current_time] Git status: $git_status uncommitted changes"
    
    # Error handling
    if ! check_dependencies; then
      echo "Dependency check failed" >&2
      exit 1
    fi
    
    # Nix-specific integration
    echo "Available Nix packages:"
    ${pkgs.tree}/bin/tree --version
    ${pkgs.git}/bin/git --version
  '';

  # Test case 4: Generic bash script (should auto-activate)  
  maintenance-script = ''
    #!/bin/bash
    # Generic bash pattern - should be detected
    
    log() {
      echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
    }
    
    cleanup() {
      log "Cleaning up temporary files"
      rm -rf "$temp_dir"
    }
    
    # Set up signal handlers
    trap cleanup EXIT INT TERM
    
    temp_dir=$(mktemp -d)
    log "Using temporary directory: $temp_dir"
    
    # Check system resources
    if [ "$(df / | awk 'NR==2 {print $5}' | sed 's/%//')" -gt 90 ]; then
      log "WARNING: Disk usage is high"
    fi
    
    # Process command line arguments
    case "$1" in
      "install")
        log "Installing packages..."
        ;;
      "update")
        log "Updating system..."
        ;;
      *)
        log "Usage: $0 {install|update}"
        exit 1
        ;;
    esac
  '';
  
  # Test case 5: Mixed languages in same configuration
  complex-plugin = {
    luaSetup = ''
      -- Lua section - should be detected
      local plugin = require('complex-plugin')
      
      plugin.setup({
        on_attach = function(client, bufnr)
          vim.notify('LSP attached to buffer ' .. bufnr)
        end,
        capabilities = require('cmp_nvim_lsp').default_capabilities()
      })
    '';
    
    shellHook = ''
      # Bash section - should be detected
      echo "Setting up plugin environment"
      
      if [ ! -d "$HOME/.local/share/complex-plugin" ]; then
        mkdir -p "$HOME/.local/share/complex-plugin"
      fi
      
      export COMPLEX_PLUGIN_DATA="$HOME/.local/share/complex-plugin"
    '';
  };
  
  # Test case 6: Advanced patterns that should trigger detection
  config.vim.extraConfigLua = ''
    -- This should also be detected as Lua
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'nix',
      callback = function()
        vim.opt_local.commentstring = '# %s'
        vim.opt_local.foldmethod = 'syntax'
      end
    })
  '';
  
  # Test case 7: Shell script with advanced features
  deployment-script = pkgs.writeShellScript "deploy" ''
    #!/bin/bash
    set -euo pipefail
    
    # Advanced bash features that should be detected
    readonly SCRIPT_DIR="$(cd "$(dirname "''${BASH_SOURCE[0]}")" && pwd)"
    readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
    
    # Associative arrays
    declare -A environments=(
      ["dev"]="development"
      ["staging"]="staging"  
      ["prod"]="production"
    )
    
    deploy_to_env() {
      local env="$1"
      local description="''${environments[$env]}"
      
      echo "Deploying to $description environment..."
      
      # Here documents
      cat << EOF > "$PROJECT_ROOT/deploy-config.yml"
environment: $env
timestamp: $(date -Iseconds)
version: $(git rev-parse --short HEAD)
EOF
      
      # Process substitution
      while read -r service; do
        echo "Restarting service: $service"
      done < <(systemctl --user list-units --state=running | grep "my-app" | cut -d' ' -f1)
    }
    
    main() {
      local env="''${1:-dev}"
      
      if [[ ! ''${environments[$env]+_} ]]; then
        echo "Unknown environment: $env" >&2
        echo "Available: ''${!environments[*]}" >&2
        exit 1
      fi
      
      deploy_to_env "$env"
    }
    
    main "$@"
  '';
}