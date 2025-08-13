# https://github.com/CopilotC-Nvim/CopilotChat.nvim
{ inputs, pkgs, ... }:
let
  # Build lua-tiktoken from source for enhanced token counting
  lua-tiktoken = pkgs.vimUtils.buildVimPlugin {
    name = "lua-tiktoken";
    src = inputs.lua-tiktoken;
  };
in
{
  config.vim = {
    assistant.copilot = {
      enable = true;
      setupOpts = {
        panel.layout.position = "right";
      };
    };
    
    # Add tiktoken as an extra package for enhanced token counting
    extraPackages = with pkgs; [
      # Try to include tiktoken-related packages
      (python3Packages.tiktoken or null)
    ];
    
    extraPlugins = {
      copilotChat = {
        package = pkgs.vimPlugins.CopilotChat-nvim;
        setup = ''
          require('CopilotChat').setup({
            -- Chat integration settings
            debug = false,
            show_help = "yes",
            
            -- Window settings for chat
            window = {
              layout = 'float',
              relative = 'cursor',
              width = 1,
              height = 0.4,
              row = 1
            },
            
            -- Mappings
            mappings = {
              complete = {
                detail = 'Use @<Tab> or /<Tab> for options.',
                insert ='<Tab>',
              },
              close = {
                normal = 'q',
                insert = '<C-c>'
              },
              reset = {
                normal ='<C-l>',
                insert = '<C-l>'
              },
              submit_prompt = {
                normal = '<CR>',
                insert = '<C-s>'
              },
              accept_diff = {
                normal = '<C-y>',
                insert = '<C-y>'
              },
              show_diff = {
                normal = 'gd'
              },
              show_system_prompt = {
                normal = 'gp'
              },
              show_user_selection = {
                normal = 'gs'
              },
            },
          })
          
          -- Add keymaps for quick access
          vim.keymap.set('n', '<leader>cc', '<cmd>CopilotChat<CR>', { desc = 'Open Copilot Chat' })
          vim.keymap.set('v', '<leader>cc', '<cmd>CopilotChatVisual<CR>', { desc = 'Open Copilot Chat with selection' })
          vim.keymap.set('n', '<leader>ce', '<cmd>CopilotChatExplain<CR>', { desc = 'Explain code' })
          vim.keymap.set('n', '<leader>ct', '<cmd>CopilotChatTests<CR>', { desc = 'Generate tests' })
          vim.keymap.set('n', '<leader>cr', '<cmd>CopilotChatReview<CR>', { desc = 'Review code' })
          vim.keymap.set('n', '<leader>cf', '<cmd>CopilotChatFixDiagnostic<CR>', { desc = 'Fix diagnostic' })
          vim.keymap.set('n', '<leader>co', '<cmd>CopilotChatOptimize<CR>', { desc = 'Optimize code' })
        '';
      };
      
      # Add lua-tiktoken for enhanced token counting
      luaTiktoken = {
        package = lua-tiktoken;
        setup = ''
          -- lua-tiktoken provides more accurate token counting for chat contexts
          -- CopilotChat will automatically use it if available
        '';
      };
    };
  };
}
