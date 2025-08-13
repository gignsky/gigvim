# Template for Adding Plugins to GigVim (nvf-based)

# This template shows how to properly add plugins to nvf-based configurations
# DO NOT use lazy.nvim - see LAZY_NVIM_ANALYSIS.md for explanation

# OPTION 1: Using nvf Built-in Modules (RECOMMENDED)
# Check https://notashelf.github.io/nvf/options.html for available modules

{ lib, ... }:
{
  config.vim = {
    # Example built-in modules - use these when available
    telescope.enable = true;
    autocomplete.blink-cmp.enable = true;
    formatter.conform-nvim.enable = true;
    
    # Language support
    languages.rust = {
      enable = true;
      lsp.enable = true;
      format.enable = true;
      treesitter.enable = true;
    };
    
    # UI enhancements
    binds.whichKey.enable = true;
    notes.todo-comments.enable = true;
  };
}

# OPTION 2: External Plugin via extraPlugins
# Use this for plugins not yet supported by nvf built-in modules
# Copy this to a new file like plugins/optional/my-plugin.nix

{ inputs, pkgs, ... }:
let
  # Build plugin from source (requires input in flake.nix)
  my-plugin-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "my-plugin-nvim";
    src = inputs.my-plugin;  # Must add to flake.nix inputs
  };
  
  # OR use plugin from nixpkgs if available
  # my-plugin-from-nixpkgs = pkgs.vimPlugins.my-plugin;
in
{
  config.vim.extraPlugins = {
    my-plugin = {
      # Choose package source
      package = my-plugin-from-source;
      # package = my-plugin-from-nixpkgs;
      
      # Lua setup code (executed at startup)
      setup = ''
        require('my-plugin').setup({
          -- Plugin configuration here
          option1 = true,
          option2 = "value",
          keymaps = {
            toggle = "<leader>mp",
          },
        })
        
        -- Additional Lua code if needed
        vim.keymap.set('n', '<leader>mp', function()
          require('my-plugin').toggle()
        end, { desc = 'Toggle My Plugin' })
      '';
      
      # Optional: Lua code executed after other plugins load  
      after = ''
        -- Code that depends on other plugins
      '';
    };
  };
}

# OPTION 3: Plugin from Git URL (without adding to flake inputs)
# Less preferred but sometimes necessary

{ pkgs, ... }:
let
  my-plugin-git = pkgs.vimUtils.buildVimPlugin {
    name = "my-plugin";
    src = pkgs.fetchFromGitHub {
      owner = "username";
      repo = "my-plugin.nvim";
      rev = "commit-hash-or-tag";
      sha256 = "sha256-hash-here";  # Get with nix-prefetch-url
    };
  };
in
{
  config.vim.extraPlugins = {
    my-plugin = {
      package = my-plugin-git;
      setup = ''require('my-plugin').setup({})'';
    };
  };
}

# STEP-BY-STEP GUIDE:

# 1. For Built-in Modules:
#    - Check nvf options: https://notashelf.github.io/nvf/options.html
#    - Add configuration to appropriate module (plugins/default.nix, lang/, etc.)
#    - Test with: nix build

# 2. For External Plugins (flake input method):
#    a. Add input to flake.nix:
#       my-plugin = {
#         url = "github:username/my-plugin.nvim";
#         flake = false;
#       };
#    
#    b. Copy this template to plugins/optional/my-plugin.nix
#    c. Modify the plugin configuration
#    d. Import in full.nix or minimal.nix:
#       imports = [ ./plugins/optional/my-plugin.nix ];
#    e. Test with: nix build

# 3. For nixpkgs Plugins:
#    - Check if plugin exists: nix search nixpkgs vim-plugins.plugin-name
#    - Use package = pkgs.vimPlugins.plugin-name;
#    - No need to add to flake inputs

# EXAMPLES OF PROPER nvf USAGE:

# Tree-sitter with custom parsers
config.vim.treesitter = {
  enable = true;
  grammars = [ pkgs.tree-sitter-grammars.tree-sitter-nix ];
};

# LSP with custom server
config.vim.lsp = {
  enable = true;
  lspconfig.servers = {
    nil_ls = {
      enable = true;
      package = pkgs.nil;
    };
  };
};

# Custom keymaps
config.vim.maps = {
  normal = {
    "<leader>ff" = {
      action = "<cmd>Telescope find_files<CR>";
      desc = "Find files";
    };
  };
};

# WHY NOT lazy.nvim?
# - Conflicts with nvf's build-time plugin management
# - Breaks reproducibility
# - No performance benefit with nvf
# - See LAZY_NVIM_ANALYSIS.md for full explanation