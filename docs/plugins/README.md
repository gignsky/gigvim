# Snacks.nvim Integration for GigVim

## Overview

This directory contains a comprehensive integration of [folke/snacks.nvim](https://github.com/folke/snacks.nvim) into the GigVim nvf-based Neovim configuration. Snacks.nvim is a collection of 26+ small quality-of-life plugins that enhance the Neovim experience.

## Files Structure

```
docs/plugins/
├── snacks-nvim.md                    # Comprehensive documentation
├── snacks-nvim-integration.md       # Integration guide
└── snacks-nvim-full-example.nix     # Example full configuration

plugins/optional/
├── snacks-nvim.nix                  # Default configuration (recommended)
├── TEMPLATE-snacks-nvim-minimal.nix # Conservative setup
├── TEMPLATE-snacks-nvim-dev.nix     # Development-focused setup
└── TEMPLATE-snacks-nvim-full.nix    # Comprehensive setup

flake.nix                            # Updated with snacks-nvim input
```

## Configuration Options

### 1. Default Configuration (`snacks-nvim.nix`)
**Recommended for most users**

- **Enabled snacks**: bigfile, dashboard, explorer, indent, input, notifier, picker, quickfile, scope, scroll, statuscolumn, words
- **Features**: Core QoL improvements, file explorer, picker, notifications, smooth scrolling
- **Conflicts**: Moderate - may conflict with existing dashboard or file explorer
- **Usage**: Basic setup with essential enhancements

### 2. Minimal Configuration (`TEMPLATE-snacks-nvim-minimal.nix`)
**Conservative setup for cautious users**

- **Enabled snacks**: bigfile, input, notifier, quickfile
- **Features**: Essential improvements only
- **Conflicts**: Minimal - very low risk
- **Usage**: When you want snacks benefits with minimal changes

### 3. Developer Configuration (`TEMPLATE-snacks-nvim-dev.nix`)
**Development-focused workflows**

- **Enabled snacks**: Core + debug, picker, profiler, git integration, terminal, scratch buffers
- **Features**: Enhanced development tools, debugging, git integration
- **Conflicts**: Moderate - may conflict with existing git/terminal plugins
- **Usage**: Development environments with enhanced tooling

### 4. Full Configuration (`TEMPLATE-snacks-nvim-full.nix`)
**Power users wanting all features**

- **Enabled snacks**: All 26+ snacks with comprehensive configuration
- **Features**: Complete snacks.nvim experience
- **Conflicts**: High - extensive potential conflicts
- **Usage**: Power users who want to fully leverage snacks.nvim

## Quick Start

### 1. Choose Configuration
Copy the desired configuration template or use the default:

```nix
# In your full.nix
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

## Key Features by Configuration

### Default Configuration Features

| Feature | Description | Keybind |
|---------|-------------|---------|
| **File Picker** | Smart file finding with fuzzy search | `<leader>ff` |
| **Recent Files** | Quick access to recently opened files | `<leader>fr` |
| **Text Search** | Grep across project files | `<leader>fg` |
| **Buffer Picker** | Navigate between open buffers | `<leader>fb` |
| **File Explorer** | Built-in file tree explorer | `<leader>e` |
| **Dashboard** | Beautiful startup dashboard | Auto on startup |
| **Notifications** | Enhanced notification system | `<leader>n` (history) |
| **Big File Handling** | Optimized handling of large files | Automatic |
| **Smooth Scrolling** | Smooth scrolling animations | Automatic |
| **Status Column** | Enhanced gutter with git signs | Automatic |
| **Word Navigation** | LSP reference navigation | `]]` / `[[` |

### Developer Configuration Additions

| Feature | Description | Keybind |
|---------|-------------|---------|
| **Git Browse** | Open files in browser (GitHub/GitLab) | `<leader>gB` |
| **LazyGit** | Integrated LazyGit terminal | `<leader>gg` |
| **Terminal** | Floating terminal windows | `<C-/>` |
| **Scratch Buffers** | Temporary scratch files | `<leader>.` |
| **Debug Tools** | Enhanced debugging utilities | `dd()`, `bt()` |
| **Profiler** | Lua performance profiling | `:lua Snacks.profiler` |
| **LSP Integration** | Enhanced LSP pickers | `gd`, `gr`, `gI` |

## Plugin Integrations

### Compatible with GigVim
- ✅ **Themes**: Works with all GigVim themes
- ✅ **Language Servers**: Enhances LSP experience
- ✅ **nvf core**: Fully compatible with nvf framework
- ✅ **Mini plugins**: Can coexist with mini.nvim suite

### Potential Conflicts
- ⚠️ **Telescope**: Picker conflicts (choose one or use different keymaps)
- ⚠️ **Dashboard-nvim**: Dashboard conflicts (disable one)
- ⚠️ **Nvim-tree/Neo-tree**: Explorer conflicts (choose one)
- ⚠️ **Nvim-notify**: Notification conflicts (snacks.notifier replaces)

## Configuration Examples

### Enable Additional Snacks
```nix
# Add to your configuration
config.vim.extraPlugins.snacks.setup = ''
  require('snacks').setup({
    -- Enable git features
    git = { enabled = true },
    gitbrowse = { enabled = true },
    lazygit = { enabled = true },
    
    -- Enable zen mode
    zen = { 
      enabled = true,
      width = 0.8,
      height = 0.8,
    },
  })
'';
```

### Custom Keymaps
```nix
# Add custom keymaps
vim.keymap.set("n", "<leader>my", function() 
  require("snacks").picker.files({ cwd = "~/my-project" }) 
end, { desc = "My Project Files" })
```

### Custom Styling
```nix
# Customize appearance
styles = {
  picker = {
    border = "double",
    width = 0.9,
    height = 0.9,
  },
  notification = {
    border = "rounded",
    wo = { wrap = true },
  },
}
```

## Performance Considerations

1. **Animations**: Disabled by default in templates for better performance
2. **Lazy Loading**: Some snacks support lazy loading patterns
3. **Selective Enabling**: Only enable needed snacks
4. **Startup Time**: Monitor with profiler snack

## Migration Guide

### From Telescope
1. Test snacks.picker functionality
2. Migrate custom telescope configurations
3. Update keymaps gradually
4. Disable telescope when satisfied

### From Other Plugins
- **Dashboard**: Compare dashboard features and migrate sections
- **File Explorer**: Test file operations and git integration
- **Notifications**: Update notification handling code

## Troubleshooting

### Common Issues
1. **Build failures**: Check flake.nix input declaration
2. **Plugin not loading**: Verify extraPlugins configuration
3. **Keymaps conflicts**: Review existing keymaps
4. **Performance issues**: Disable unused snacks

### Debug Commands
```vim
:lua print(vim.inspect(require("snacks.config")))
:checkhealth snacks
:lua require("snacks").profiler.start()
```

## External Resources

- [Main Repository](https://github.com/folke/snacks.nvim)
- [Official Documentation](https://github.com/folke/snacks.nvim/tree/main/docs)
- [Examples Directory](https://github.com/folke/snacks.nvim/tree/main/docs/examples)
- [Individual Snack Docs](https://github.com/folke/snacks.nvim/tree/main/docs)

## Contributing

To improve this integration:

1. Test with different nvf setups
2. Document conflicts and solutions
3. Add new configuration patterns
4. Update documentation

---

*This integration provides a comprehensive, documented, and templated approach to using snacks.nvim within the nvf framework, following GigVim's patterns and best practices.*