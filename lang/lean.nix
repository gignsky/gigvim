# Lean Language Support Configuration
# Lean theorem prover and functional programming language support
# 
# Lean is a modern theorem prover and programming language for mathematics
# and formal verification. This configuration provides comprehensive support
# for Lean development with language server integration.
#
# Features enabled:
# - TreeSitter syntax highlighting for Lean files
# - Lean 4 language server for formal verification
# - File type detection for .lean files
# - Integration with Lean's proof assistant features
# - Unicode input support for mathematical symbols
#
# Language server features:
# - Real-time proof checking and verification
# - Goal state display and proof guidance
# - Lean library completion and documentation
# - Error reporting and diagnostic information
# - Interactive theorem proving support
#
# Additional Lean integration:
# - lean.nvim plugin provides enhanced Lean-specific features
# - Goal state visualization and proof navigation
# - Interactive tactic execution and exploration

{ pkgs, ... }:
{
  config.vim.languages.lean = {
    enable = true;
    treesitter.enable = true;
    
    # Enable Lean language server
    lsp = {
      enable = true;
      package = pkgs.lean4;
      server = "leanls";
    };
    
    # No specific formatter for Lean (handled by language server)
    # format.enable = false;
  };
  
  # Additional Lean tools via extraPackages
  config.vim.extraPackages = with pkgs; [
    lean4         # Lean 4 language and tools
    elan          # Lean version manager
  ];
  
  # File type associations for Lean files
  config.vim.extraConfigLua = ''
    -- Ensure Lean files are properly detected
    vim.filetype.add({
      extension = {
        lean = "lean",
      },
      filename = {
        ["lakefile.lean"] = "lean",
        ["*.lean"] = "lean",
      },
      pattern = {
        [".*%.lean"] = "lean",
      }
    })
    
    -- Lean-specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lean",
      callback = function()
        -- Set Lean-specific options
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
        vim.opt_local.commentstring = "-- %s"
        
        -- Enable Unicode input for mathematical symbols
        vim.opt_local.keymap = "lean"
        
        -- Lean-specific keybindings
        vim.keymap.set('n', '<leader>li', '<cmd>LeanInfoview<cr>', { 
          desc = 'Toggle Lean infoview',
          buffer = true 
        })
        vim.keymap.set('n', '<leader>lg', '<cmd>LeanGoal<cr>', { 
          desc = 'Show Lean goal state',
          buffer = true 
        })
        vim.keymap.set('n', '<leader>lt', '<cmd>LeanTacticState<cr>', { 
          desc = 'Show Lean tactic state',
          buffer = true 
        })
        vim.keymap.set('n', '<leader>lc', '<cmd>LeanCheck<cr>', { 
          desc = 'Check Lean file',
          buffer = true 
        })
        
        -- Enhanced Lean development workflow
        vim.keymap.set('i', '<C-space>', function()
          -- Trigger completion specifically for Lean symbols
          require('blink.cmp').show()
        end, { 
          desc = 'Lean symbol completion',
          buffer = true 
        })
      end,
    })
    
    -- Unicode abbreviations for common mathematical symbols
    vim.cmd([[
      autocmd FileType lean inoreabbrev <buffer> -> →
      autocmd FileType lean inoreabbrev <buffer> <- ←
      autocmd FileType lean inoreabbrev <buffer> <-> ↔
      autocmd FileType lean inoreabbrev <buffer> => ⇒
      autocmd FileType lean inoreabbrev <buffer> <=> ⇔
      autocmd FileType lean inoreabbrev <buffer> /\ ∧
      autocmd FileType lean inoreabbrev <buffer> \/ ∨
      autocmd FileType lean inoreabbrev <buffer> ~ ¬
      autocmd FileType lean inoreabbrev <buffer> forall ∀
      autocmd FileType lean inoreabbrev <buffer> exists ∃
      autocmd FileType lean inoreabbrev <buffer> lambda λ
      autocmd FileType lean inoreabbrev <buffer> alpha α
      autocmd FileType lean inoreabbrev <buffer> beta β
      autocmd FileType lean inoreabbrev <buffer> gamma γ
      autocmd FileType lean inoreabbrev <buffer> delta δ
      autocmd FileType lean inoreabbrev <buffer> epsilon ε
      autocmd FileType lean inoreabbrev <buffer> theta θ
      autocmd FileType lean inoreabbrev <buffer> pi π
      autocmd FileType lean inoreabbrev <buffer> sigma σ
      autocmd FileType lean inoreabbrev <buffer> tau τ
      autocmd FileType lean inoreabbrev <buffer> phi φ
      autocmd FileType lean inoreabbrev <buffer> psi ψ
      autocmd FileType lean inoreabbrev <buffer> omega ω
      autocmd FileType lean inoreabbrev <buffer> Gamma Γ
      autocmd FileType lean inoreabbrev <buffer> Delta Δ
      autocmd FileType lean inoreabbrev <buffer> Theta Θ
      autocmd FileType lean inoreabbrev <buffer> Lambda Λ
      autocmd FileType lean inoreabbrev <buffer> Pi Π
      autocmd FileType lean inoreabbrev <buffer> Sigma Σ
      autocmd FileType lean inoreabbrev <buffer> Phi Φ
      autocmd FileType lean inoreabbrev <buffer> Psi Ψ
      autocmd FileType lean inoreabbrev <buffer> Omega Ω
      autocmd FileType lean inoreabbrev <buffer> in ∈
      autocmd FileType lean inoreabbrev <buffer> notin ∉
      autocmd FileType lean inoreabbrev <buffer> subset ⊆
      autocmd FileType lean inoreabbrev <buffer> supset ⊇
      autocmd FileType lean inoreabbrev <buffer> union ∪
      autocmd FileType lean inoreabbrev <buffer> inter ∩
      autocmd FileType lean inoreabbrev <buffer> empty ∅
      autocmd FileType lean inoreabbrev <buffer> infty ∞
      autocmd FileType lean inoreabbrev <buffer> sum Σ
      autocmd FileType lean inoreabbrev <buffer> prod Π
      autocmd FileType lean inoreabbrev <buffer> int ∫
    ]])
  '';
}