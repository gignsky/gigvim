# Embedded Language Support

This configuration enables automatic LSP and syntax highlighting for embedded languages within Nix files using otter-nvim.

## Automatic Detection

Otter-nvim automatically activates when opening Nix files that contain embedded code patterns. No manual activation required for common patterns.

## Supported Patterns

### Lua in Plugin Setup Strings

For nvf plugin configurations with setup strings:

```nix
config.vim.extraPlugins = {
  my-plugin = {
    package = pkgs.vimPlugins.some-plugin;
    setup = ''
      -- This Lua code will have syntax highlighting and LSP support
      require('some-plugin').setup({
        option = "value",
        nested = {
          key = true
        }
      })
      
      -- Full vim API support
      vim.keymap.set('n', '<leader>t', function()
        print("Hello from embedded Lua!")
      end)
    '';
  };
};
```

### Bash in Shell Scripts

For `writeShellScriptBin` and similar patterns:

```nix
my-script = pkgs.writeShellScriptBin "my-script" ''
  #!/bin/bash
  # This bash code will have syntax highlighting and LSP support
  echo "Hello World"
  
  if [ -d "$HOME" ]; then
    echo "Home directory exists"
  fi
  
  for file in *.nix; do
    echo "Processing $file"
  done
  
  ${pkgs.tree}/bin/tree --version
'';
```

### Generic Language Support

The configuration also detects embedded languages in generic string contexts:

```nix
# Lua configuration
luaConfig = ''
  local config = { enabled = true }
  function setup()
    vim.notify("Setup complete")
  end
'';

# Bash scripts
bashScript = ''
  echo "Generic bash detection"
  export PATH="$PATH:/custom/bin"
'';
```

## Features

- **Automatic Detection**: Files containing supported patterns automatically activate otter-nvim
- **LSP Support**: Full language server support for embedded code (lua-language-server, bash-language-server)
- **Syntax Highlighting**: Treesitter-based syntax highlighting for embedded languages  
- **Manual Control**: Keybindings for manual otter control and debugging
- **Multi-language**: Support for multiple embedded languages in the same file

## Keybindings

- `<leader>lo` - Activate Otter for current buffer
- `<leader>ld` - Deactivate Otter for current buffer
- `<leader>lL` - Force activate Otter with all supported languages  
- `<leader>lr` - Rename symbol (otter-aware)
- `<leader>lf` - Format code (otter-aware)
- `<leader>li` - Show otter status/info
- `<leader>le` - Hover/evaluation support for embedded code

## How It Works

1. **Content Analysis**: When opening .nix files, content is analyzed for embedded language patterns
2. **Automatic Activation**: If patterns are detected, otter-nvim activates with appropriate languages
3. **Treesitter Injections**: Custom injection queries provide syntax highlighting
4. **LSP Integration**: Language servers work seamlessly within embedded code blocks
5. **Smart Detection**: Patterns include Lua (require/vim API calls) and Bash (shebangs/shell constructs)

## Supported Languages

Currently configured for:
- **Lua**: Full support with lua-language-server (enabled in lang/lua.nix)
- **Bash**: Full support with bash-language-server (enabled in lang/bash.nix)  
- **Shell**: Generic shell script support

Additional languages can be added by:
1. Enabling language support in the `lang/` directory
2. Adding detection patterns to `config/otter.nix`
3. Adding treesitter injection queries to `config/treesitter-injections.nix`

## Testing

Test files are provided:
- `test-cases.nix` - Contains example patterns for manual testing
- `/tmp/test_embedded_languages.nix` - Comprehensive test cases
- Open in nvim and verify:
  - Automatic otter activation (check with `<leader>li`)
  - Syntax highlighting for embedded code
  - LSP functionality (hover, go-to-definition, etc.)
  - Code completion within embedded blocks

## Troubleshooting

### Debugging Activation
- Use `<leader>li` to check otter status
- Use `<leader>lL` to force activation with all languages
- Check LSP status with `:LspInfo` while in embedded code

### Manual Activation
If automatic detection fails:
```
<leader>lo  " Basic activation
<leader>lL  " Force activation with all languages
```

### Language Server Issues
Ensure language servers are available:
- Lua: lua-language-server (included with lang/lua.nix)
- Bash: bash-language-server (included with lang/bash.nix)

## Dependencies

This feature requires:
- `otter-nvim` (enabled in config/otter.nix)
- Lua language support (lang/lua.nix)
- Bash language support (lang/bash.nix)  
- Treesitter with Nix, Lua, and Bash grammars
- Language servers for embedded languages