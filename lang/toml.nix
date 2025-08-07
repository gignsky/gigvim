# TOML Language Support Configuration
# Configuration for TOML (Tom's Obvious, Minimal Language) support in Neovim
# 
# TOML is commonly used for configuration files in Rust projects (Cargo.toml),
# Python projects (pyproject.toml), and many other applications.
#
# Features enabled:
# - TreeSitter syntax highlighting for TOML files
# - Basic formatting support
# - File type detection for .toml files
#
# Language servers available but not enabled by default:
# - taplo: TOML language server (https://taplo.tamasfe.dev/)
#
# To enable taplo LSP, uncomment the lsp section below

{ pkgs, ... }:
{
  config.vim.languages.toml = {
    enable = true;
    treesitter.enable = true;
    
    # Uncomment to enable TOML language server (taplo)
    # lsp = {
    #   enable = true;
    #   package = pkgs.taplo;
    #   server = "taplo";
    # };
    
    # Basic formatting - no specific formatter for TOML in nvf
    # format.enable = false;
  };
  
  # File type associations
  config.vim.extraConfigLua = ''
    -- Ensure TOML files are properly detected
    vim.filetype.add({
      extension = {
        toml = "toml",
      },
      filename = {
        ["Cargo.toml"] = "toml",
        ["pyproject.toml"] = "toml",
        ["Pipfile"] = "toml",
      }
    })
  '';
}