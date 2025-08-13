# Embedded Language Support

This configuration enables LSP and syntax highlighting for embedded languages within Nix files.

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
    '';
  };
};
```

### Bash in Shell Scripts

For `writeShellScriptBin` patterns common in Nix packages:

```nix
my-script = pkgs.writeShellScriptBin "my-script" ''
  #!/bin/bash
  # This bash code will have syntax highlighting and LSP support
  echo "Hello World"
  ${pkgs.tree}/bin/tree --version
'';
```

## Features

- **Automatic Detection**: Files containing the supported patterns automatically activate otter-nvim
- **LSP Support**: Full language server support for embedded code
- **Syntax Highlighting**: Treesitter-based syntax highlighting for embedded languages
- **Manual Control**: Keybindings for manual otter control

## Keybindings

- `<leader>lo` - Activate Otter for current buffer
- `<leader>ld` - Deactivate Otter for current buffer  
- `<leader>lr` - Rename symbol (otter-aware)
- `<leader>lf` - Format code (otter-aware)
- `<leader>li` - Show otter status/info

## How It Works

1. **Treesitter Injections**: Custom treesitter queries identify embedded code blocks
2. **Otter-nvim**: Provides multi-language LSP support within single files
3. **Auto-activation**: File patterns trigger automatic language detection and activation
4. **LSP Integration**: Full language server features work within embedded code blocks

## Testing

Test files are provided:
- `test-cases.nix` - Contains example patterns for manual testing
- Open in nvim and verify syntax highlighting and LSP functionality

## Dependencies

This feature requires:
- `otter-nvim` (already enabled in lang/default.nix)
- Lua language support (lua.nix)
- Bash language support (bash.nix)
- Treesitter with Nix grammar