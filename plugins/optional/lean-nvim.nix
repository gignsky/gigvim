# lean.nvim Plugin Configuration
# Enhanced Lean theorem prover integration for Neovim
# Repository: https://github.com/Julian/lean.nvim
#
# lean.nvim provides sophisticated integration with the Lean theorem prover,
# offering interactive proof development, goal state visualization, and
# enhanced mathematical notation support.
#
# Features enabled:
# - Interactive goal state window (infoview)
# - Real-time proof checking and feedback
# - Lean-specific keybindings and commands
# - Integration with Lean language server
# - Enhanced mathematical symbol input
# - Proof tactic autocompletion
#
# Settings configured:
# - Infoview window for goal state display
# - Keybindings for common Lean operations
# - Integration with completion engine
# - Mathematical Unicode input helpers
#
# Settings still need to be configured:
# - Custom Lean project templates
# - Advanced proof automation preferences
# - Integration with external Lean tools

{ inputs, pkgs, ... }:
let
  lean-nvim-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "lean-nvim";
    src = inputs.lean-nvim;
  };
in
{
  config.vim.extraPlugins = {
    lean = {
      package = lean-nvim-from-source;
      setup = ''
        require('lean').setup({
          -- Infoview configuration
          infoview = {
            autoopen = true,        -- Automatically open infoview
            width = 50,             -- Width of infoview window
            height = 20,            -- Height of infoview window  
            horizontal_position = "bottom", -- Position: "bottom" or "top"
            separate_tab = false,   -- Open infoview in separate tab
            indicators = "auto",    -- Show proof indicators: "auto", "always", "never"
            
            -- Show specific information in infoview
            show_processing = true,
            show_no_info_message = true,
            
            -- Styling options
            use_widgets = true,
            mappings = {
              K = "click",          -- Click to interact with widgets
              ["<CR>"] = "click",   -- Enter to click
              I = "mouse_enter",    -- I to mouse enter
              i = "mouse_leave",    -- i to mouse leave
            },
          },
          
          -- Progress bar configuration
          progress_bars = {
            enable = true,
            priority = 10,
          },
          
          -- Redirect Lean's stderr to infoview
          stderr = {
            enable = true,
            height = 5,
          },
          
          -- Abbreviations for mathematical symbols (enhanced)
          abbreviations = {
            enable = true,
            extra = {
              -- Additional mathematical abbreviations
              ["real"] = "ℝ",
              ["nat"] = "ℕ", 
              ["int"] = "ℤ",
              ["rat"] = "ℚ",
              ["complex"] = "ℂ",
              ["bool"] = "𝔹",
              ["prop"] = "Prop",
              ["type"] = "Type",
              ["sort"] = "Sort",
              
              -- Common logical symbols
              ["iff"] = "↔",
              ["implies"] = "→",
              ["and"] = "∧",
              ["or"] = "∨",
              ["not"] = "¬",
              ["eq"] = "=",
              ["ne"] = "≠",
              ["le"] = "≤",
              ["ge"] = "≥",
              ["lt"] = "<",
              ["gt"] = ">",
              
              -- Set theory
              ["mem"] = "∈",
              ["nmem"] = "∉",
              ["subset"] = "⊆",
              ["supset"] = "⊇",
              ["ssubset"] = "⊂",
              ["ssupset"] = "⊃",
              ["cap"] = "∩",
              ["cup"] = "∪",
              ["diff"] = "\\",
              ["symdiff"] = "△",
              
              -- Functions and arrows
              ["mapsto"] = "↦",
              ["comp"] = "∘",
              ["circ"] = "∘",
            },
          },
          
          -- LSP configuration (integrates with our existing LSP setup)
          lsp = {
            on_attach = function(client, bufnr)
              -- Additional Lean-specific LSP setup
              vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
              
              -- Lean-specific keybindings
              local opts = { noremap=true, silent=true, buffer=bufnr }
              vim.keymap.set('n', '<leader>li', '<cmd>LeanInfoviewToggle<cr>', vim.tbl_extend('force', opts, { desc = 'Toggle Lean infoview' }))
              vim.keymap.set('n', '<leader>lp', '<cmd>LeanInfoviewPause<cr>', vim.tbl_extend('force', opts, { desc = 'Pause Lean infoview' }))
              vim.keymap.set('n', '<leader>lr', '<cmd>LeanInfoviewResume<cr>', vim.tbl_extend('force', opts, { desc = 'Resume Lean infoview' }))
              vim.keymap.set('n', '<leader>lc', '<cmd>LeanInfoviewClear<cr>', vim.tbl_extend('force', opts, { desc = 'Clear Lean infoview' }))
              vim.keymap.set('n', '<leader>ls', '<cmd>LeanSorryFill<cr>', vim.tbl_extend('force', opts, { desc = 'Fill sorry with goal' }))
              vim.keymap.set('n', '<leader>lt', '<cmd>LeanTryThis<cr>', vim.tbl_extend('force', opts, { desc = 'Try this suggestion' }))
            end,
          },
          
          -- Mappings for Lean-specific commands
          mappings = true,
        })
        
        -- Additional Lean workflow commands
        vim.api.nvim_create_user_command('LeanInfoviewToggle', function()
          require('lean.infoview').toggle()
        end, { desc = 'Toggle Lean infoview' })
        
        vim.api.nvim_create_user_command('LeanInfoviewPause', function()
          require('lean.infoview').pause()
        end, { desc = 'Pause Lean infoview' })
        
        vim.api.nvim_create_user_command('LeanInfoviewResume', function()
          require('lean.infoview').resume()  
        end, { desc = 'Resume Lean infoview' })
        
        vim.api.nvim_create_user_command('LeanInfoviewClear', function()
          require('lean.infoview').clear()
        end, { desc = 'Clear Lean infoview' })
        
        vim.api.nvim_create_user_command('LeanSorryFill', function()
          require('lean.sorry').fill()
        end, { desc = 'Fill sorry with current goal' })
        
        vim.api.nvim_create_user_command('LeanTryThis', function()
          require('lean.trythis').swap()
        end, { desc = 'Apply "Try this" suggestion' })
        
        -- Auto-commands for Lean development
        vim.api.nvim_create_augroup("LeanNvimAutoCommands", { clear = true })
        
        -- Auto-open infoview for Lean files
        vim.api.nvim_create_autocmd("BufEnter", {
          group = "LeanNvimAutoCommands",
          pattern = "*.lean",
          callback = function()
            -- Delay to let LSP start
            vim.defer_fn(function()
              require('lean.infoview').open()
            end, 1000)
          end,
        })
        
        -- Auto-save Lean files on focus lost (helpful for continuous checking)
        vim.api.nvim_create_autocmd("FocusLost", {
          group = "LeanNvimAutoCommands", 
          pattern = "*.lean",
          callback = function()
            vim.cmd('silent! write')
          end,
        })
      '';
    };
  };
}