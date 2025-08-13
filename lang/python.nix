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
# - Python environment detection (see plugins/optional/python/python-env-switcher/)
# - Python import helpers (see plugins/optional/python/python-import.nix)
# - F-string helpers (see plugins/optional/python/f-string-toggle.nix)

{ pkgs, ... }:
{
  imports = [
    # Python environment switchers (choose one based on preference)
    # ../plugins/optional/python/python-env-switcher/whichpy.nix    # Automatic environment detection
    # ../plugins/optional/python/python-env-switcher/swenv.nix      # Manual environment switching

    # Python development enhancements
    ../plugins/optional/python/python-import.nix # Intelligent import management
    ../plugins/optional/python/f-string-toggle.nix # F-string conversion tools
  ];

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
      types = [
        "flake8"
        "mypy"
      ];
    };
  };

  # Additional Python tools via extraPackages
  config.vim.extraPackages = with pkgs; [
    # Python development tools
    black # Code formatter
    isort # Import sorter
    flake8 # Linter
    mypy # Type checker
    pylint # Additional linter
    autopep8 # PEP 8 formatter
    python3Packages.pep8-naming # PEP 8 naming conventions

    # Python environment management
    python3Packages.virtualenv # Virtual environment creation
    python3Packages.pip # Package installer
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
        
        -- Python development workflow keybindings
        vim.keymap.set('n', '<leader>pr', '<cmd>!python %<cr>', { 
          desc = 'Run Python file',
          buffer = true 
        })
        vim.keymap.set('n', '<leader>pt', '<cmd>!python -m pytest<cr>', { 
          desc = 'Run Python tests',
          buffer = true 
        })
        vim.keymap.set('n', '<leader>pm', '<cmd>!python -m mypy %<cr>', { 
          desc = 'Run mypy on current file',
          buffer = true 
        })
        vim.keymap.set('n', '<leader>pb', '<cmd>!python -m black %<cr>', { 
          desc = 'Format with black',
          buffer = true 
        })
      end,
    })

    -- Python project detection and workflow
    vim.api.nvim_create_augroup("PythonProjectAutoCommands", { clear = true })

    -- Detect Python project type and show relevant information
    vim.api.nvim_create_autocmd("VimEnter", {
      group = "PythonProjectAutoCommands",
      callback = function()
        local project_files = {
          { file = "pyproject.toml", type = "Poetry/Modern Python" },
          { file = "Pipfile", type = "Pipenv" },
          { file = "requirements.txt", type = "pip" },
          { file = "setup.py", type = "setuptools" },
          { file = "environment.yml", type = "conda" },
          { file = ".python-version", type = "pyenv" },
        }
        
        for _, project in ipairs(project_files) do
          if vim.fn.filereadable(project.file) == 1 then
            vim.defer_fn(function()
              vim.notify(
                string.format("Detected %s project", project.type),
                vim.log.levels.INFO,
                { title = "Python Project" }
              )
            end, 1000)
            break
          end
        end
      end,
    })
  '';
}
