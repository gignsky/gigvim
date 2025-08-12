# ❌ EXAMPLE: Why lazy.nvim CANNOT work with nvf
# 
# This file demonstrates why lazy.nvim is incompatible with nvf.
# DO NOT actually use this configuration!
# See LAZY_NVIM_ANALYSIS.md for full explanation.

{ inputs, pkgs, ... }:
let
  # This is how someone might try to add lazy.nvim
  lazy-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "lazy.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "lazy.nvim";
      rev = "main";
      sha256 = "...";  # Would need actual hash
    };
  };
in
{
  # ❌ PROBLEMS with this approach:
  
  config.vim.extraPlugins = {
    lazy-nvim = {
      package = lazy-nvim;
      setup = ''
        -- This setup would conflict with nvf's plugin management
        require("lazy").setup({
          -- lazy.nvim would try to manage plugins that nvf already manages
          "nvim-telescope/telescope.nvim",  -- ❌ Already managed by nvf
          "hrsh7th/nvim-cmp",              -- ❌ Conflicts with blink-cmp setup
          
          -- Even for new plugins, this creates problems:
          {
            "new/plugin.nvim",
            config = function()
              -- ❌ Runtime plugin installation conflicts with Nix immutability
              -- ❌ Plugin state would be mutable, breaking reproducibility  
              -- ❌ Version pinning would be bypassed
            end
          }
        })
      '';
    };
  };
  
  # Additional problems:
  # 1. lazy.nvim expects plugins in ~/.local/share/nvim/lazy/
  # 2. nvf puts plugins in /nix/store/ (immutable)
  # 3. lazy.nvim would try to git clone during runtime
  # 4. nvf builds everything at build time
  # 5. Version conflicts between Nix packages and lazy.nvim git repos
  # 6. Two different loading mechanisms would conflict
}

# ✅ CORRECT APPROACH: Use nvf's built-in modules instead
# 
# Instead of lazy.nvim, do this:
{
  config.vim = {
    # Built-in module (preferred)
    telescope.enable = true;
    
    # External plugin via extraPlugins (when no built-in module exists)
    extraPlugins = {
      my-new-plugin = {
        package = pkgs.vimUtils.buildVimPlugin { ... };
        setup = ''require('my-new-plugin').setup({})'';
      };
    };
  };
}

# PERFORMANCE COMPARISON:
# 
# lazy.nvim approach:
# 1. Neovim starts
# 2. lazy.nvim loads
# 3. lazy.nvim checks which plugins to load
# 4. Plugins loaded on-demand (lazy loading benefit)
# 
# nvf approach:
# 1. All plugins pre-compiled into single Neovim package
# 2. Neovim starts with everything ready (actually faster!)
# 3. No runtime plugin resolution overhead
# 4. Optimized by Nix build system
#
# Result: nvf is actually faster than lazy.nvim for startup!