# YAML Language Support Configuration  
# Configuration for YAML (YAML Ain't Markup Language) support in Neovim
#
# YAML is widely used for configuration files, CI/CD pipelines,
# Kubernetes manifests, Docker Compose files, and many other applications.
#
# Features enabled:
# - TreeSitter syntax highlighting for YAML files
# - yaml-language-server for LSP support
# - prettier formatting for YAML files
# - File type detection for various YAML file extensions
#
# Language server features:
# - Syntax validation and error checking
# - Schema validation for common YAML formats
# - Auto-completion for YAML keys and values
# - Hover documentation
#
# Additional YAML plugins are available in plugins/optional/yaml-*.nix

{ pkgs, ... }:
{
  config.vim.languages.yaml = {
    enable = true;
    treesitter.enable = true;
    
    # Enable YAML language server
    lsp = {
      enable = true;
      package = pkgs.yaml-language-server;
      server = "yamlls";
    };
    
    # Enable formatting with prettier
    format = {
      enable = true;
      type = "prettier";
      package = pkgs.nodePackages.prettier;
    };
  };
  
  # File type associations for various YAML files
  config.vim.extraConfigLua = ''
    -- Ensure YAML files are properly detected
    vim.filetype.add({
      extension = {
        yaml = "yaml",
        yml = "yaml",
      },
      filename = {
        [".clang-format"] = "yaml",
        [".clang-tidy"] = "yaml", 
        [".prettierrc"] = "yaml",
        ["docker-compose.yml"] = "yaml",
        ["docker-compose.yaml"] = "yaml",
        [".github/workflows/*"] = "yaml",
        [".gitlab-ci.yml"] = "yaml",
        ["ansible.cfg"] = "yaml",
        ["playbook.yml"] = "yaml",
        ["inventory.yml"] = "yaml",
      },
      pattern = {
        ["%.kube/config"] = "yaml",
        ["%.github/workflows/.*%.ya?ml"] = "yaml",
        ["%.gitlab-ci%.ya?ml"] = "yaml",
        ["docker%-compose%.ya?ml"] = "yaml",
        ["ansible%.cfg"] = "yaml",
        [".*%.ansible%.ya?ml"] = "yaml",
        [".*playbook.*%.ya?ml"] = "yaml",
        [".*inventory.*%.ya?ml"] = "yaml",
      }
    })
  '';
}