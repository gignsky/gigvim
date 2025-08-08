# f-string-toggle.nvim Plugin Configuration
# Toggle between Python string formats (f-strings, .format(), % formatting)
# Repository: https://github.com/roobert/f-string-toggle.nvim
#
# f-string-toggle.nvim provides seamless conversion between different Python
# string formatting methods. It's particularly useful for modernizing code
# to use f-strings or adapting code for different Python versions.
#
# Features enabled:
# - Toggle between f-string, .format(), and % formatting
# - Intelligent variable detection and extraction
# - Preservation of string content and formatting
# - Support for complex expressions in f-strings
# - Multi-line string handling
#
# Supported conversions:
# - "Hello {}".format(name) ↔ f"Hello {name}"
# - "Hello %s" % name ↔ f"Hello {name}"
# - f"Hello {name}" ↔ "Hello {}".format(name)
# - Smart handling of expressions and method calls
#
# Settings configured:
# - Keybindings for quick format toggling
# - Intelligent format detection and conversion
# - Preservation of string escape sequences
# - Support for nested expressions
#
# Settings still need to be configured:
# - Custom conversion rules for specific patterns
# - Project-wide formatting preferences
# - Integration with code formatters

{ inputs, pkgs, ... }:
let
  f-string-toggle-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "f-string-toggle-nvim";
    src = inputs.f-string-toggle-nvim;
  };
in
{
  config.vim.extraPlugins = {
    f-string-toggle = {
      package = f-string-toggle-from-source;
      setup = ''
        require('f-string-toggle').setup({
          -- Key binding configuration
          key_binding = "<leader>f",  -- Default toggle binding
          
          -- String detection patterns
          patterns = {
            -- f-string patterns
            fstring = {
              'f"[^"]*"',
              "f'[^']*'",
              'f"""[^"]*"""',
              "f'''[^']*'''",
            },
            
            -- .format() patterns  
            format_method = {
              '"[^"]*"%.format%([^)]*%)',
              "'[^']*'%.format%([^)]*%)",
              '"""[^"]*"""%.format%([^)]*%)',
              "'''[^']*'''%.format%([^)]*%)",
            },
            
            -- % formatting patterns
            percent_format = {
              '"[^"]*" %% [^%s]+',
              "'[^']*' %% [^%s]+",
              '"[^"]*" %% %([^)]*%)',
              "'[^']*' %% %([^)]*%)",
            },
          },
          
          -- Conversion behavior
          conversion = {
            -- Prefer f-strings when converting
            prefer_fstring = true,
            
            -- Handle multiline strings
            multiline = true,
            
            -- Preserve original quotes (single vs double)
            preserve_quotes = false,
            
            -- Handle complex expressions
            handle_expressions = true,
          },
          
          -- Safety checks
          safety = {
            -- Validate Python syntax after conversion
            validate_syntax = true,
            
            -- Show preview before conversion
            show_preview = false,
            
            -- Confirm destructive changes
            confirm_changes = false,
          },
          
          -- Visual feedback
          ui = {
            -- Highlight string being converted
            highlight_conversion = true,
            
            -- Show notifications on conversion
            notify = true,
            
            -- Notification timeout (ms)
            notify_timeout = 2000,
          },
        })
        
        -- Enhanced key mappings for different conversion types
        vim.keymap.set('n', '<leader>ft', function()
          require('f-string-toggle').toggle()
        end, { 
          desc = 'Toggle Python string format',
          silent = true 
        })
        
        vim.keymap.set('v', '<leader>ft', function()
          require('f-string-toggle').toggle()
        end, { 
          desc = 'Toggle Python string format (selection)',
          silent = true 
        })
        
        -- Specific conversion functions
        vim.keymap.set('n', '<leader>ff', function()
          require('f-string-toggle').to_fstring()
        end, { 
          desc = 'Convert to f-string',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>fm', function()
          require('f-string-toggle').to_format_method()
        end, { 
          desc = 'Convert to .format() method',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>fp', function()
          require('f-string-toggle').to_percent_format()
        end, { 
          desc = 'Convert to % formatting',
          silent = true 
        })
        
        -- Line and visual selections
        vim.keymap.set('v', '<leader>ff', function()
          require('f-string-toggle').to_fstring()
        end, { 
          desc = 'Convert selection to f-string',
          silent = true 
        })
        
        vim.keymap.set('v', '<leader>fm', function()
          require('f-string-toggle').to_format_method()
        end, { 
          desc = 'Convert selection to .format() method',
          silent = true 
        })
        
        vim.keymap.set('v', '<leader>fp', function()
          require('f-string-toggle').to_percent_format()
        end, { 
          desc = 'Convert selection to % formatting',
          silent = true 
        })
        
        -- Buffer-wide operations
        vim.keymap.set('n', '<leader>fA', function()
          require('f-string-toggle').convert_all_to_fstring()
        end, { 
          desc = 'Convert all strings to f-strings',
          silent = true 
        })
        
        vim.keymap.set('n', '<leader>fM', function()
          require('f-string-toggle').convert_all_to_format_method()
        end, { 
          desc = 'Convert all strings to .format() method',
          silent = true 
        })
        
        -- Commands for string format conversion
        vim.api.nvim_create_user_command('FStringToggle', function()
          require('f-string-toggle').toggle()
        end, { desc = 'Toggle Python string format' })
        
        vim.api.nvim_create_user_command('FStringToFString', function()
          require('f-string-toggle').to_fstring()
        end, { desc = 'Convert to f-string' })
        
        vim.api.nvim_create_user_command('FStringToFormat', function()
          require('f-string-toggle').to_format_method()
        end, { desc = 'Convert to .format() method' })
        
        vim.api.nvim_create_user_command('FStringToPercent', function()
          require('f-string-toggle').to_percent_format()
        end, { desc = 'Convert to % formatting' })
        
        vim.api.nvim_create_user_command('FStringConvertAll', function(opts)
          local target = opts.args or "fstring"
          if target == "fstring" then
            require('f-string-toggle').convert_all_to_fstring()
          elseif target == "format" then
            require('f-string-toggle').convert_all_to_format_method()
          elseif target == "percent" then
            require('f-string-toggle').convert_all_to_percent_format()
          else
            vim.notify("Invalid target: " .. target .. ". Use 'fstring', 'format', or 'percent'", vim.log.levels.ERROR)
          end
        end, { 
          desc = 'Convert all strings to specified format',
          nargs = '?',
          complete = function() return { "fstring", "format", "percent" } end
        })
        
        -- Auto-commands for enhanced Python string workflow
        vim.api.nvim_create_augroup("FStringToggleAutoCommands", { clear = true })
        
        -- Show string format info on cursor hold
        vim.api.nvim_create_autocmd("CursorHold", {
          group = "FStringToggleAutoCommands",
          pattern = "*.py",
          callback = function()
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            
            -- Check if cursor is on a string
            local string_type = require('f-string-toggle').detect_string_type(line, col)
            if string_type then
              vim.api.nvim_echo({
                { string.format("String format: %s (press <leader>ft to toggle)", string_type), "Comment" }
              }, false, {})
            end
          end,
        })
        
        -- Auto-modernize to f-strings on file save (optional)
        -- Uncomment the following to automatically convert old-style strings to f-strings
        --[[
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = "FStringToggleAutoCommands",
          pattern = "*.py",
          callback = function()
            -- Only auto-convert in certain circumstances
            local file_size = vim.fn.getfsize(vim.fn.expand('%'))
            if file_size < 10000 then  -- Only small files
              require('f-string-toggle').convert_all_to_fstring()
            end
          end,
        })
        --]]
      '';
    };
  };
}