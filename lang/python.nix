# Python Language Support Configuration
# Comprehensive Python development support for Neovim
#
# Python is one of the most popular programming languages for data science,
# web development, automation, and general-purpose programming.
#
# Features enabled:
# - TreeSitter syntax highlighting for Python files
# - pyright language server for type checking and IntelliSense
# - black formatter for code formatting
# - isort for import sorting (via null-ls)
# - flake8 for linting (via null-ls)
# - mypy for type checking (via null-ls)
# - File type detection for Python files and scripts
#
# Language server features:
# - Type checking and inference
# - Auto-completion with type hints
# - Go to definition and references
# - Hover documentation
# - Refactoring support
# - Import organization
#
# Additional Python tools and plugins:
# - Python environment detection (see plugins/optional/python-env-switcher/)
# - Python import helpers (see plugins/optional/python-import.nix)
# - F-string helpers (see plugins/optional/f-string-toggle.nix)

{ pkgs, ... }:
{
  config.vim.languages.python = {
    enable = true;
    treesitter.enable = true;
    
    # Enable Python language server (pyright)
    lsp = {
      enable = true;
      package = pkgs.pyright;
      server = "pyright";
    };
    
    # Enable formatting with black
    format = {
      enable = true;
      type = "black";
      package = pkgs.black;
    };
    
    # Enable extra diagnostics
    extraDiagnostics = {
      enable = true;
      types = [ "flake8" "mypy" ];
    };
  };
  
  # Additional Python tools via extraPackages
  config.vim.extraPackages = with pkgs; [
    # Python development tools
    black           # Code formatter
    isort           # Import sorter
    flake8          # Linter
    mypy            # Type checker
    pylint          # Additional linter
    autopep8        # PEP 8 formatter
    python3Packages.pep8-naming  # PEP 8 naming conventions
  ];
  
  # File type associations for Python files
  config.vim.extraConfigLua = ''
    -- Ensure Python files are properly detected
    vim.filetype.add({
      extension = {
        py = "python",
        pyi = "python",  -- Type stub files
        pyw = "python",  -- Windows Python files
      },
      filename = {
        [".pythonrc"] = "python",
        ["requirements.txt"] = "requirements",
        ["requirements-dev.txt"] = "requirements", 
        ["requirements-test.txt"] = "requirements",
        ["Pipfile"] = "toml",
        ["pyproject.toml"] = "toml",
        ["setup.py"] = "python",
        ["setup.cfg"] = "dosini",
        ["tox.ini"] = "dosini",
        ["pytest.ini"] = "dosini",
        [".coveragerc"] = "dosini",
        ["mypy.ini"] = "dosini",
      },
      pattern = {
        ["requirements.*%.txt"] = "requirements",
        [".*%.pyi"] = "python",  -- Type stub files
      }
    })
    
    -- Python-specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python", 
      callback = function()
        -- Set Python-specific options
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.expandtab = true
        vim.opt_local.textwidth = 88  -- Black's default line length
        vim.opt_local.colorcolumn = "89"
        
        -- Enable spell checking in comments and strings
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
      end,
    })
  '';
}