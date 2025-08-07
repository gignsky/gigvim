# wtf.nvim Plugin Configuration
# AI-powered error explanation and debugging assistant
# Repository: https://github.com/piersolenski/wtf.nvim
#
# wtf.nvim provides AI-powered explanations for errors, diagnostics,
# and code issues. It can integrate with various LLM providers including
# local self-hosted models for privacy and cost control.
#
# Features enabled:
# - AI explanations for LSP diagnostics and error messages
# - Support for multiple LLM backends (OpenAI, local models)
# - Context-aware code analysis
# - Popup and buffer display modes
# - Configurable keybindings for quick access
#
# Settings configured:
# - Default OpenAI configuration (can be overridden for local LLMs)
# - Popup display for quick explanations
# - Integration with LSP diagnostics
# - Keybindings for common operations
#
# Local LLM Integration:
# See resources/local-llm-integration.md for comprehensive guide on
# setting up local LLMs (Ollama, llamafile, text-generation-webui)
# that can replace OpenAI API calls for privacy and cost savings.
#
# Settings still need to be configured:
# - API keys for chosen LLM provider
# - Custom prompts for specific use cases
# - Per-language explanation preferences

{ inputs, pkgs, ... }:
let
  wtf-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "wtf-nvim";
    src = inputs.wtf-nvim;
  };
in
{
  config.vim.extraPlugins = {
    wtf = {
      package = wtf-from-source;
      setup = ''
        require('wtf').setup({
          -- Default popup configuration
          popup_type = "popup",  -- "popup" or "horizontal" or "vertical"
          
          -- OpenAI configuration (default - can be overridden for local LLMs)
          openai_api_key = os.getenv("OPENAI_API_KEY") or "your-api-key-here",
          openai_model_id = "gpt-3.5-turbo",
          
          -- For local LLM integration (uncomment and configure as needed):
          -- Ollama example:
          -- openai_api_key = "not-needed-for-local",
          -- openai_model_id = "codellama:13b",
          -- openai_api_base = "http://localhost:11434/v1",
          
          -- Text Generation WebUI example:
          -- openai_api_key = "not-needed-for-local", 
          -- openai_model_id = "gpt-3.5-turbo", -- Any name works
          -- openai_api_base = "http://localhost:5000/v1",
          
          -- llamafile example:
          -- openai_api_key = "not-needed-for-local",
          -- openai_model_id = "local-model",
          -- openai_api_base = "http://localhost:8080/v1",
          
          -- Context configuration
          context = true,  -- Include surrounding code context
          language = "english",  -- Response language
          
          -- Additional system prompt for better coding assistance
          additional_instructions = [[
            Please provide clear, concise explanations for programming errors and issues.
            Focus on:
            1. What the error means in plain language
            2. Common causes of this type of error
            3. Specific steps to fix the issue
            4. Best practices to prevent similar issues
            
            If the error is in a specific programming language, provide language-specific advice.
            Include code examples when helpful.
          ]],
          
          -- Popup window configuration
          popup = {
            -- Popup dimensions
            relative = "editor",
            position = {
              row = "50%",
              col = "50%",
            },
            size = {
              width = "80%",
              height = "80%",
            },
            
            -- Border and styling
            border = {
              chars = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
              highlight = "WtfBorder",
            },
            
            -- Window options
            win_options = {
              wrap = true,
              linebreak = true,
              foldcolumn = "0",
              cursorline = false,
            },
          },
          
          -- Keybindings within the popup
          keys = {
            quit = { "q", "<Esc>" },
            accept = { "<CR>" },
            explain_again = { "r" },
            copy_to_clipboard = { "c" },
          },
          
          -- Hooks for custom behavior
          hooks = {
            request_started = function()
              vim.notify("WTF: Analyzing error...", vim.log.levels.INFO)
            end,
            request_finished = function(response)
              if response and response.error then
                vim.notify("WTF: Error - " .. response.error, vim.log.levels.ERROR)
              else
                vim.notify("WTF: Analysis complete", vim.log.levels.INFO)
              end
            end,
          },
        })
        
        -- Key mappings for wtf operations
        vim.keymap.set('n', '<leader>we', function()
          require('wtf').ai()
        end, { 
          desc = 'WTF: Explain error under cursor',
          silent = true 
        })
        
        vim.keymap.set('v', '<leader>we', function()
          require('wtf').ai()
        end, { 
          desc = 'WTF: Explain selected text',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>wd', function()
          require('wtf').ai({
            additional_instructions = "Focus specifically on debugging this issue step by step."
          })
        end, { 
          desc = 'WTF: Debug mode explanation',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>ws', function()
          require('wtf').search()
        end, { 
          desc = 'WTF: Search for solutions online',
          silent = true 
        })
        
        -- Integration with LSP diagnostics
        vim.keymap.set('n', '<leader>wl', function()
          local line = vim.api.nvim_win_get_cursor(0)[1] - 1
          local diagnostics = vim.diagnostic.get(0, { lnum = line })
          
          if #diagnostics > 0 then
            local diagnostic = diagnostics[1]
            local message = diagnostic.message
            local source = diagnostic.source or "LSP"
            
            require('wtf').ai({
              input = string.format("[%s] %s", source, message),
              additional_instructions = "This is an LSP diagnostic message. Please explain what this means and how to fix it."
            })
          else
            vim.notify("No LSP diagnostics on current line", vim.log.levels.WARN)
          end
        end, { 
          desc = 'WTF: Explain LSP diagnostic',
          silent = true 
        })
        
        -- Auto-command to show notification about local LLM setup
        vim.api.nvim_create_augroup("WtfSetupNotification", { clear = true })
        vim.api.nvim_create_autocmd("VimEnter", {
          group = "WtfSetupNotification",
          once = true,
          callback = function()
            -- Check if API key is set up
            local api_key = os.getenv("OPENAI_API_KEY")
            if not api_key or api_key == "" or api_key == "your-api-key-here" then
              vim.defer_fn(function()
                vim.notify([[
WTF.nvim is configured but needs API setup:
• For OpenAI: Set OPENAI_API_KEY environment variable
• For local LLMs: See :help gigvim-local-llm or resources/local-llm-integration.md
• Use :e resources/local-llm-integration.md for comprehensive local setup guide
                ]], vim.log.levels.WARN, { title = "WTF.nvim Setup" })
              end, 2000)
            end
          end,
        })
        
        -- Command for opening the local LLM documentation
        vim.api.nvim_create_user_command('WtfLocalLLMHelp', function()
          vim.cmd('edit ' .. vim.fn.stdpath('config') .. '/../resources/local-llm-integration.md')
        end, { desc = 'Open local LLM integration guide' })
      '';
    };
  };
}