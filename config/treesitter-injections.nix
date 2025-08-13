# Treesitter injection configuration for embedded languages
# Provides better syntax highlighting for embedded code in Nix files

{ pkgs, ... }:
{
  config.vim = {
    # Enhanced treesitter configuration with injection support via extraPlugins
    extraPlugins = {
      treesitter-injections = {
        package = pkgs.vimUtils.buildVimPlugin {
          name = "treesitter-injections";
          src = pkgs.writeText "treesitter-injections" "";
        };
        setup = ''
          -- Setup treesitter injection queries for embedded languages
          local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
          
          -- Enhanced Nix treesitter setup with injection queries
          if parser_config.nix then
            parser_config.nix.used_by = parser_config.nix.used_by or {}
            table.insert(parser_config.nix.used_by, "nix")
          end
          
          -- Setup injection queries for common patterns
          vim.schedule(function()
            -- Custom injection query for Nix files with embedded languages
            local nix_injections = [[
              ; Lua in extraPlugins setup strings
              ((string_expression
                (indented_string_expression) @injection.content)
                (#match? @injection.content "(require|vim\\.|function|local)")
                (#set! injection.language "lua"))
              
              ; Bash in writeShellScriptBin
              ((string_expression  
                (indented_string_expression) @injection.content)
                (#match? @injection.content "(#!/bin/(ba)?sh|echo|if \\[|for |while )")
                (#set! injection.language "bash"))
                
              ; Generic shell detection
              ((string_expression
                (indented_string_expression) @injection.content)
                (#match? @injection.content "\\$\\{[^}]+\\}")
                (#set! injection.language "bash"))
            ]]
            
            -- Try to set the injection query
            pcall(function()
              vim.treesitter.query.set('nix', 'injections', nix_injections)
            end)
          end)
        '';
      };
    };
    
    # Ensure required treesitter parsers are available
    extraPackages = with pkgs; [
      tree-sitter-grammars.tree-sitter-nix
      tree-sitter-grammars.tree-sitter-lua
      tree-sitter-grammars.tree-sitter-bash
    ];
  };
}