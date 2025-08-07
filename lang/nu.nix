# Nu Shell Language Support Configuration
# Enhanced configuration for Nushell (Nu) support in Neovim
#
# Nushell is a modern shell with structured data pipelines,
# strong typing, and cross-platform support.
#
# Features enabled:
# - TreeSitter syntax highlighting for Nu files (.nu)
# - Language server support for Nu shell
# - File type detection for Nushell scripts and config files
# - Nu-specific editor settings and key mappings
#
# Language server features:
# - Syntax validation and error checking
# - Auto-completion for Nu commands and functions
# - Hover documentation for built-in commands
# - Go to definition for custom functions
#
# Note: Nushell LSP support is still evolving, some features may be limited

{ pkgs, ... }:
{
  config.vim.languages.nu = {
    enable = true;
    treesitter.enable = true;
    
    # Enable Nu language server
    lsp = {
      enable = true;
      # Note: nushell package includes the LSP server
      package = pkgs.nushell;
      server = "nushell";
    };
    
    # No specific formatter configured yet for Nu
    # format.enable = false;
  };
  
  # File type associations for Nu shell files
  config.vim.extraConfigLua = ''
    -- Ensure Nu shell files are properly detected
    vim.filetype.add({
      extension = {
        nu = "nu",
      },
      filename = {
        ["config.nu"] = "nu",
        ["env.nu"] = "nu",
        ["login.nu"] = "nu",
        ["profile.nu"] = "nu",
      },
      pattern = {
        [".*%.nu"] = "nu",
        ["config%.nu"] = "nu",
        ["env%.nu"] = "nu",
      }
    })
    
    -- Nu shell specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "nu",
      callback = function()
        -- Set Nu-specific options
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
        vim.opt_local.commentstring = "# %s"
        
        -- Enable spell checking in comments and strings
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
      end,
    })
  '';
  
  # Include Nu shell in extraPackages for completeness
  config.vim.extraPackages = with pkgs; [
    nushell  # Nu shell with LSP support
  ];
}
