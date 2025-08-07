# GigVim - Nix-based Neovim Configuration

GigVim is a Nix Flake-based Neovim configuration using the nvf (NeoVim Flake) framework. It provides a highly customizable and reproducible development environment with language support, plugins, and themes configured declaratively.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Prerequisites and Setup
- Install Nix package manager: `sudo apt-get update && sudo apt-get install -y nix-bin`
- Enable Nix daemon: `sudo systemctl enable --now nix-daemon`
- Add user to nix-users group: `sudo usermod -a -G nix-users $USER && newgrp nix-users`
- Enable experimental features for flakes: `export NIX_CONFIG="experimental-features = nix-command flakes"`

### Build and Validation Commands
- Validate flake configuration: `nix flake check` -- takes 2-3 minutes with network retries. NEVER CANCEL. Set timeout to 10+ minutes.
- Show available packages: `nix flake show` -- takes 30 seconds. Shows three configurations: default, full, minimal.
- Build default configuration: `nix build` -- takes 30-45 minutes on first run. NEVER CANCEL. Set timeout to 60+ minutes.
- Build specific configuration: `nix build .#minimal` or `nix build .#full`
- Enter development shell: `nix develop` -- takes 15-30 minutes on first run. NEVER CANCEL. Set timeout to 45+ minutes.

### Network and Dependency Requirements
- **CRITICAL**: All build commands require internet access to download Nix packages from cache.nixos.org
- Build will fail with "Couldn't resolve host name" errors if network is unavailable
- First builds download large dependency trees (2000+ packages)
- Subsequent builds use local cache and are much faster (2-5 minutes)

## Repository Structure

### Core Configuration Files
```
├── flake.nix          # Main flake configuration with inputs and outputs
├── flake.lock         # Locked dependency versions
├── full.nix           # Full feature configuration (imports minimal.nix)
├── minimal.nix        # Base configuration with core imports
├── .envrc             # direnv configuration for automatic environment loading
├── .gitignore         # Git ignore patterns
└── resources/         # Static resources (sounds, documentation, etc.)
    ├── sounds/        # Audio files for plugins (minecraft sounds for beepboop.nvim)
    └── zips/          # Archive storage
```

### Configuration Modules
```
├── config/            # Core editor configuration
│   ├── default.nix    # Main config imports and global settings
│   └── core/          # Core editor options (brackets, line numbers, etc.)
├── plugins/           # Plugin configurations  
│   ├── default.nix    # Plugin imports and core plugin settings
│   ├── core/          # Essential plugins
│   └── optional/      # Optional plugin configurations
│       ├── TEMPLATE-external-plugin.nix  # Template for adding external plugins
│       ├── themery-nvim.nix             # Theme switcher plugin
│       └── mini.nix                     # Mini.nvim plugin configuration
├── lang/              # Language-specific configurations
│   ├── default.nix    # Language imports and global language settings
│   ├── bash.nix       # Bash language support
│   ├── nix.nix        # Nix language support (LSP: nil, formatter: nixfmt)
│   ├── rust.nix       # Rust language support (LSP: rust-analyzer, formatter: rustfmt)
│   └── nu.nix         # Nu shell support
├── binds/             # Key binding configurations
│   └── default.nix    # Custom keymaps (jj for Escape, etc.)
└── themes/            # Theme configurations
    ├── default.nix    # Theme imports
    └── catppuccin/    # Catppuccin theme variants
```

## Available Configurations

### Default/Full Configuration (`nix build` or `nix build .#full`)
- Complete Neovim setup with all features enabled
- Language servers: nil (Nix), rust-analyzer (Rust), bash-language-server
- Formatters: nixfmt-rfc-style, rustfmt, shfmt
- Core plugins: telescope, blink-cmp, conform-nvim, luasnip, todo-comments, fzf-lua
- Optional plugins: themery-nvim (theme switcher)
- Features: LSP, treesitter, autocomplete, formatting, debugging support, theme switching
- Includes resources: minecraft sounds for audio feedback plugins

### Minimal Configuration (`nix build .#minimal`)
- Basic Neovim setup with essential features only
- Includes core language support and essential plugins
- Includes mini.nvim plugin for lightweight functionality
- Suitable for lightweight environments and development shells

## Home Manager Integration

GigVim provides a Home Manager module for easy integration:

```nix
{
  programs.gigvim = {
    enable = true;
    package = inputs.gigvim.packages.${pkgs.stdenv.hostPlatform.system}.full;
  };
}
```

This automatically:
- Installs the configured Neovim package
- Sets EDITOR and VISUAL environment variables
- Makes nvim available in PATH

## Development Workflow

### Making Configuration Changes
1. Edit relevant .nix files in config/, plugins/, lang/, binds/, or themes/
2. Validate syntax: `nix flake check` -- takes 2-3 minutes. NEVER CANCEL.
3. Test configuration: `nix build` -- takes 5-45 minutes depending on changes. NEVER CANCEL.
4. Run the editor: `./result/bin/nvim` to test your changes

### Formatting and Linting
- Format Nix files: `nix run .#formatter` (uses nixfmt)
- The flake includes nixfmt as the default formatter
- Always format before committing changes

### Adding New Language Support
1. Create new file in `lang/` directory (e.g., `python.nix`)
2. Configure language-specific settings:
   ```nix
   {pkgs, ...}: {
     config.vim.languages.python = {
       enable = true;
       lsp = {
         enable = true;
         package = pkgs.pyright;
         server = "pyright";
       };
       format = {
         enable = true;
         type = "black";
         package = pkgs.black;
       };
       treesitter.enable = true;
     };
   }
   ```
3. Import in `lang/default.nix`
4. Rebuild and test: `nix build`

### Adding New Plugins
1. For external plugins not in nixpkgs:
   - Add the plugin source to flake.nix inputs with `flake = false`
   - Use the TEMPLATE-external-plugin.nix as a reference
   - Create configuration in `plugins/core/` or `plugins/optional/`
2. For plugins already in nvf:
   - Check the nvf options documentation at https://notashelf.github.io/nvf/options.html
   - Create configuration using `config.vim.*` options directly
   - Still organize in appropriate plugin category folders
3. Import in `plugins/default.nix` or relevant configuration files
4. Rebuild and test the configuration

### Plugin Organization
Plugins are organized by functionality:
- `plugins/core/` - Essential plugins included in both minimal and full configurations
- `plugins/optional/` - Optional plugins included only in full configuration
- Consider organizing by categories like:
  - `plugins/language/` - Language-specific plugins
  - `plugins/ui/` - Interface and appearance plugins
  - `plugins/workflow/` - Productivity and workflow plugins
  - `plugins/utility/` - General utility plugins

## Validation and Testing

### Manual Validation Steps
After making any changes, always perform these validation steps:
1. **Syntax Check**: `nix flake check` -- validates all Nix syntax
2. **Build Test**: `nix build` -- ensures configuration builds successfully  
3. **Functionality Test**: `./result/bin/nvim --version` -- verify Neovim launches
4. **Plugin Test**: Open nvim and test affected plugins/features
5. **LSP Test**: Open a source file and verify language server functionality

### Common Validation Scenarios
- **Language Support**: Open files of configured languages and verify syntax highlighting, LSP, and formatting
- **Key Bindings**: Test custom keymaps (jj for Escape, etc.)
- **Plugin Functionality**: Verify telescope, autocomplete, and other plugins work correctly
- **Theme Application**: Check that themes are applied correctly

## Troubleshooting

### Network Issues
- If builds fail with "Couldn't resolve host name": Check internet connectivity
- Network timeouts are normal - builds retry automatically
- Use `--offline` flag only if you have all dependencies cached locally

### Build Failures
- Check flake syntax first: `nix flake check`
- Review error messages for missing dependencies or syntax errors
- Ensure all imported files exist and are properly referenced

### Performance Issues
- First builds are always slow (30-45 minutes)
- Use `nix build --no-link` to avoid creating result symlinks during testing
- Clear build cache if experiencing persistent issues: `nix store gc`

### Home Manager Issues
- Ensure gigvim input is properly added to your flake inputs
- Verify Home Manager module is imported correctly
- Check that the package reference matches your system architecture

## Dependencies and External Tools

The configuration automatically includes these tools:
- `nil` - Nix language server
- `nixfmt-rfc-style` - Nix formatter (RFC 166 compliant)
- `alejandra` - Alternative Nix formatter (legacy, being phased out)
- `tree-sitter` - Syntax highlighting
- `rust-analyzer` - Rust language server
- `rustfmt` - Rust formatter
- `bash-language-server` - Bash LSP support
- `shfmt` - Shell script formatter

## Build Time Expectations

- **NEVER CANCEL**: All build commands take significant time
- `nix flake check`: 2-3 minutes (with network retries)
- `nix flake show`: 30 seconds
- `nix build` (first time): 30-45 minutes
- `nix build` (incremental): 2-5 minutes
- `nix develop` (first time): 15-30 minutes
- `nix develop` (incremental): 1-2 minutes

Always set timeouts to at least double these estimates to account for network variability and system performance differences.