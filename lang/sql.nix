# SQL Language Support Configuration
# Comprehensive SQL development support for Neovim
#
# SQL is essential for database development, data analysis, and backend systems.
# This configuration provides syntax highlighting, formatting, and language server support.
#
# Features enabled:
# - TreeSitter syntax highlighting for SQL files
# - sqls language server for SQL IntelliSense
# - sqlfluff formatter for SQL code formatting
# - File type detection for various SQL file extensions
# - Database connection support (via sqls)
#
# Language server features:
# - SQL syntax validation and error checking
# - Database schema completion
# - Query optimization suggestions
# - Cross-reference resolution
# - Hover documentation for SQL functions
#
# Additional SQL tools available:
# - sqls.nvim plugin for enhanced database integration
# - Database explorers and query runners
# - Custom SQL snippets for common patterns

{ pkgs, ... }:
{
  config.vim.languages.sql = {
    enable = true;
    treesitter.enable = true;
    
    # Enable SQL language server (sqls)
    lsp = {
      enable = true;
      package = pkgs.sqls;
      server = "sqls";
    };
    
    # Enable formatting with sqlfluff
    format = {
      enable = true;
      type = "sqlfluff";
      package = pkgs.sqlfluff;
    };
  };
  
  # Additional SQL tools via extraPackages
  config.vim.extraPackages = with pkgs; [
    sqls          # SQL language server
    sqlfluff      # SQL linter and formatter
    sqlite        # SQLite database engine
    postgresql    # PostgreSQL client tools
  ];
  
  # File type associations for SQL files
  config.vim.extraConfigLua = ''
    -- Ensure SQL files are properly detected
    vim.filetype.add({
      extension = {
        sql = "sql",
        psql = "sql",
        mysql = "sql",
        pgsql = "sql",
        plsql = "sql",
      },
      filename = {
        ["*.sql"] = "sql",
        ["*.SQL"] = "sql",
      },
      pattern = {
        [".*%.sql"] = "sql",
        [".*%.psql"] = "sql", 
        [".*%.mysql"] = "sql",
        [".*%.pgsql"] = "sql",
        [".*%.plsql"] = "sql",
      }
    })
    
    -- SQL-specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "sql",
      callback = function()
        -- Set SQL-specific options
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
        vim.opt_local.commentstring = "-- %s"
        
        -- Enable spell checking in comments
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
        
        -- SQL-specific keybindings
        vim.keymap.set('n', '<leader>se', '<cmd>SqlExecute<cr>', { 
          desc = 'Execute SQL query',
          buffer = true 
        })
        vim.keymap.set('v', '<leader>se', '<cmd>SqlExecuteSelection<cr>', { 
          desc = 'Execute selected SQL',
          buffer = true 
        })
      end,
    })
  '';
}