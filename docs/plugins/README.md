# Snacks.nvim Integration for GigVim

## Overview

This directory contains a comprehensive integration of [folke/snacks.nvim](https://github.com/folke/snacks.nvim) into the GigVim nvf-based Neovim configuration. Snacks.nvim is a collection of 26+ small quality-of-life plugins that enhance the Neovim experience.

## Files Structure

```
docs/plugins/
├── snacks-nvim.md                    # Comprehensive documentation
├── snacks/
│   ├── dashboard.md                  # Dashboard plugin documentation
│   ├── picker.md                     # File/buffer picker documentation  
│   ├── lazygit.md                    # Git integration documentation
│   └── indent.md                     # Indent guides documentation

plugins/optional/
├── snacks-nvim.nix                  # Default configuration (recommended)
└── TEMPLATE-snacks-nvim-minimal.nix # Conservative setup

binds/
├── snacks-nvim.nix                  # Keybinding configuration

flake.nix                            # Updated with snacks-nvim input
```

## Configuration Options

### 1. Default Configuration (`snacks-nvim.nix`)
**Recommended for most users**

- **Enabled snacks**: bigfile, dashboard, explorer, indent, input, notifier, picker, quickfile, dim, animate, bufdelete, debug, health, layout, profiler, terminal
- **Features**: Core QoL improvements, file explorer, picker, notifications, git integration, smooth animations
- **Usage**: Comprehensive setup with essential enhancements

### 2. Minimal Configuration (`TEMPLATE-snacks-nvim-minimal.nix`)
**Conservative setup for cautious users**

- **Enabled snacks**: bigfile, input, notifier, quickfile
- **Features**: Essential improvements only
- **Conflicts**: Minimal - very low risk
- **Usage**: When you want snacks benefits with minimal changes

## Quick Start

### 1. Already Integrated
The snacks.nvim integration is already included in the `full.nix` configuration:

```nix
# In your full.nix (already done)
let
  snacksModule = import ./plugins/optional/snacks-nvim.nix { inherit inputs pkgs; };
in
{
  imports = [
    ./minimal.nix
    snacksModule
  ];
}
```

### 2. Build and Test
```bash
# Validate
nix flake check

# Build
nix build

# Test
./result/bin/nvim
```

### 3. Health Check
```vim
:checkhealth snacks
```

## Key Features and Keybindings

### File Operations
| Keybind | Description | Function |
|---------|-------------|-----------|
| `<leader>ff` | Find Files | Smart file finding with fuzzy search |
| `<leader>fr` | Recent Files | Quick access to recently opened files |
| `<leader>fg` | Live Grep | Search text across project files |
| `<leader>fb` | Find Buffers | Navigate between open buffers |
| `<leader>fs` | Find Symbols | Search for symbols in current file |
| `<leader>gf` | Git Files | Find files tracked by Git |

### Git Integration
| Keybind | Description | Function |
|---------|-------------|-----------|
| `<leader>gg` | LazyGit | Integrated LazyGit terminal interface |
| `<leader>gs` | Git Blame Line | Show blame for current line |
| `<leader>gS` | Git Status | Display Git status |
| `<leader>gb` | Git Branch Info | Show current branch information |
| `<leader>go` | Git Browse | Open files in browser (GitHub/GitLab) |

### UI Enhancements
| Feature | Description | Auto-trigger |
|---------|-------------|--------------|
| **Dashboard** | Beautiful startup dashboard | Auto on startup |
| **Big File Handling** | Optimized handling of large files | Automatic |
| **Notifications** | Enhanced notification system | Automatic |
| **Indent Guides** | Visual indentation guides | Automatic |
| **Dim Effects** | Dim inactive code sections | Automatic |
| **Smooth Scrolling** | Smooth scrolling animations | Automatic |

### Development Tools
| Keybind | Description | Function |
|---------|-------------|-----------|
| `<leader>e` | File Explorer | Built-in file tree explorer |
| `<leader>t` | Terminal | Toggle floating terminal |
| `<leader>bd` | Delete Buffer | Smart buffer deletion preserving layout |
| `<leader>ba` | Delete All Buffers | Delete all buffers |
| `<leader>bo` | Delete Other Buffers | Delete all buffers except current |

## Benefits

### Performance Improvements
- **Big File Handling**: Automatic optimization for files >1.5MB
- **Quick File Loading**: Faster startup when opening files directly
- **Smooth Animations**: Enhanced visual experience

### Developer Experience  
- **Git Integration**: Seamless Git workflows with LazyGit
- **Advanced Picker**: Fast, fuzzy file and buffer finding
- **Enhanced Explorer**: Better file navigation
- **Smart Notifications**: LSP progress and enhanced messaging

### Visual Enhancements
- **Beautiful Dashboard**: Custom startup screen with GIGVIM branding
- **Indent Guides**: Clear visual code structure
- **Dim Effects**: Focus enhancement by dimming inactive code
- **Modern Interface**: Professional, polished appearance

## Integration with GigVim
- ✅ **Themes**: Works with all GigVim themes (Catppuccin, etc.)
- ✅ **Language Servers**: Enhances LSP experience
- ✅ **nvf core**: Fully compatible with nvf framework
- ✅ **Existing plugins**: Coexists with other GigVim plugins

## Testing Instructions

### Local Testing
1. Build the full configuration: `nix build .#full`
2. Run the built Neovim: `./result/bin/nvim`
3. Verify snacks.nvim is loaded:
   - `:lua print(require('snacks'))` (should return "table: 0x...")
   - Generate notifications: `:lua vim.notify("Test", vim.log.levels.INFO)`
   - Test dashboard: Start nvim without arguments

### Health Check
```vim
:checkhealth snacks
```

### Feature Verification
- **Dashboard**: Start nvim without arguments - should show GIGVIM ASCII art
- **File picker**: Try `<leader>ff`, `<leader>fb`, `<leader>fg`
- **Explorer**: Press `<leader>e` to toggle file explorer
- **Git integration**: Use `<leader>gg` for LazyGit
- **Terminal**: Press `<leader>t` for floating terminal

## Customization

To extend the configuration, you can modify the setup in `plugins/optional/snacks-nvim.nix`:

```nix
setup = ''
  require('snacks').setup({
    bigfile = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    dashboard = { enabled = true },
    -- Add more plugins as needed
  })
'';
```

## External Resources

- [Main Repository](https://github.com/folke/snacks.nvim)
- [Official Documentation](https://github.com/folke/snacks.nvim/tree/main/docs)
- [Individual Snack Docs](https://github.com/folke/snacks.nvim/tree/main/docs)

---

*This integration provides a comprehensive, documented approach to using snacks.nvim within the nvf framework, following GigVim's patterns and best practices.*