# Snacks.nvim Integration Guide for GigVim

## Overview

This guide explains how to integrate snacks.nvim into your GigVim configuration using the nvf (NeoVim Flake) framework.

## Quick Start

### 1. Add to flake.nix inputs

The snacks.nvim input is already added to the flake.nix:

```nix
snacks-nvim = {
  url = "github:folke/snacks.nvim";
  flake = false;
};
```

### 2. Choose Your Configuration Level

GigVim provides three pre-configured snacks.nvim templates:

#### Basic Configuration (Recommended for new users)
```nix
# In your full.nix or minimal.nix
imports = [
  # ... other imports
  (import ./plugins/optional/snacks-nvim.nix { inherit inputs pkgs; })
];
```

#### Minimal Configuration (Conservative setup)
```nix
# For minimal overhead
imports = [
  (import ./plugins/optional/TEMPLATE-snacks-nvim-minimal.nix { inherit inputs pkgs; })
];
```

#### Developer Configuration (Development-focused)
```nix
# For development workflows
imports = [
  (import ./plugins/optional/TEMPLATE-snacks-nvim-dev.nix { inherit inputs pkgs; })
];
```

#### Full Configuration (All features)
```nix
# For power users wanting all features
imports = [
  (import ./plugins/optional/TEMPLATE-snacks-nvim-full.nix { inherit inputs pkgs; })
];
```

### 3. Build and Test

```bash
# Validate configuration
export NIX_CONFIG="experimental-features = nix-command flakes"
nix flake check

# Build configuration
nix build

# Test the editor
./result/bin/nvim
```

## Configuration Templates

### snacks-nvim.nix (Default)
- **Snacks enabled**: bigfile, dashboard, explorer, indent, input, notifier, picker, quickfile, scope, scroll, statuscolumn, words
- **Use case**: Balanced setup with core quality-of-life improvements
- **Conflicts**: May conflict with existing dashboard, picker, or file explorer configurations

### TEMPLATE-snacks-nvim-minimal.nix
- **Snacks enabled**: bigfile, input, notifier, quickfile
- **Use case**: Conservative users wanting minimal changes to their workflow
- **Conflicts**: Minimal risk of conflicts

### TEMPLATE-snacks-nvim-dev.nix
- **Snacks enabled**: Core + debug, picker, profiler, git integration, terminal, scratch buffers
- **Use case**: Development-focused workflows with debugging and git integration
- **Conflicts**: May conflict with existing git plugins, terminal, or picker configurations

### TEMPLATE-snacks-nvim-full.nix
- **Snacks enabled**: All 26+ snacks with comprehensive configuration
- **Use case**: Power users who want to leverage all snacks.nvim capabilities
- **Conflicts**: High potential for conflicts with existing plugins

## Conflict Resolution

### Common Plugin Conflicts

1. **Dashboard/Startscreen Conflicts**
   - snacks.dashboard conflicts with: alpha-nvim, dashboard-nvim, startify
   - Solution: Disable conflicting plugins or set `dashboard = { enabled = false }`

2. **File Explorer Conflicts**
   - snacks.explorer conflicts with: nvim-tree, neo-tree, oil.nvim
   - Solution: Disable conflicting plugins or set `explorer = { enabled = false }`

3. **Picker/Finder Conflicts**
   - snacks.picker conflicts with: telescope, fzf-lua
   - Solution: Choose one picker system or configure both with different keymaps

4. **Notification Conflicts**
   - snacks.notifier conflicts with: nvim-notify, mini.notify
   - Solution: Disable conflicting plugins or set `notifier = { enabled = false }`

5. **Scroll/Animation Conflicts**
   - snacks.scroll conflicts with: neoscroll, smooth-scrolling plugins
   - Solution: Disable conflicting plugins or set `scroll = { enabled = false }`

### nvf-Specific Considerations

1. **extraPlugins Priority**
   - Snacks.nvim should be loaded early (priority = 1000, lazy = false)
   - May need to adjust other plugin loading order

2. **vim.ui Replacements**
   - snacks.input replaces vim.ui.input
   - May conflict with other UI replacement plugins

3. **LSP Integration**
   - Some snacks integrate with LSP (words, picker, rename)
   - Ensure LSP is properly configured before enabling these snacks

## Customization

### Enabling/Disabling Individual Snacks

```nix
# In your configuration file
setup = ''
  require('snacks').setup({
    -- Enable specific snacks
    dashboard = { enabled = true },
    picker = { enabled = true },
    
    -- Disable specific snacks
    zen = { enabled = false },
    terminal = { enabled = false },
    
    -- Configure snack options
    notifier = {
      enabled = true,
      timeout = 5000,
      width = { min = 40, max = 0.6 },
    },
  })
'';
```

### Custom Keymaps

```nix
# Add custom keymaps in the setup section
vim.keymap.set("n", "<leader>my", function() 
  require("snacks").picker.files({ cwd = "~/my-project" }) 
end, { desc = "My Project Files" })
```

### Styling

```nix
# Customize window styles
styles = {
  notification = {
    border = "double",
    wo = { wrap = true },
  },
  picker = {
    border = "rounded",
    width = 0.9,
    height = 0.9,
  },
},
```

## Health Check

After setup, run the health check to verify configuration:

```vim
:checkhealth snacks
```

Common issues and solutions:

- **Missing dependencies**: Install required tools (git, ripgrep, fd)
- **Keymap conflicts**: Review and resolve conflicting keymaps
- **Performance issues**: Disable unused snacks or animations

## Migration Strategies

### From Telescope to Snacks Picker

1. **Gradual migration**: Enable snacks.picker alongside telescope
2. **Different keymaps**: Use different leader keys for each
3. **Feature comparison**: Test equivalent functionality
4. **Full switch**: Disable telescope after successful migration

### From Dashboard-nvim to Snacks Dashboard

1. **Compare features**: Ensure snacks.dashboard meets your needs
2. **Custom sections**: Migrate custom dashboard sections
3. **Keymaps**: Update dashboard-related keymaps

### From Nvim-tree to Snacks Explorer

1. **Feature parity**: Test file operations and navigation
2. **Keymaps**: Update file explorer keymaps
3. **Integration**: Check integration with git and other tools

## Performance Considerations

1. **Disable animations**: Set `animate = { enabled = false }` for better performance
2. **Selective enabling**: Only enable snacks you actively use
3. **Lazy loading**: Some snacks support lazy loading patterns
4. **Startup time**: Monitor startup time with `:StartupTime` or similar

## Troubleshooting

### Build Failures

1. **Missing inputs**: Ensure snacks-nvim input is properly declared
2. **Syntax errors**: Check Nix syntax in configuration files
3. **Import errors**: Verify import paths and parameter passing

### Runtime Issues

1. **Plugin not loading**: Check extraPlugins configuration
2. **Keymaps not working**: Verify keymap conflicts and setup
3. **Features missing**: Ensure snacks are explicitly enabled
4. **Performance problems**: Profile and disable problematic snacks

### Debug Commands

```vim
" Check snacks configuration
:lua print(vim.inspect(require("snacks.config")))

" Debug specific snack
:lua require("snacks").debug.inspect(require("snacks.picker").config)

" Health check
:checkhealth snacks
```

## External Resources

- [Official Documentation](https://github.com/folke/snacks.nvim)
- [Individual Snack Docs](https://github.com/folke/snacks.nvim/tree/main/docs)
- [Examples](https://github.com/folke/snacks.nvim/tree/main/docs/examples)
- [Health Check Guide](https://github.com/folke/snacks.nvim/blob/main/docs/health.md)

## Contributing

To improve these templates or add new configurations:

1. Test thoroughly with different nvf setups
2. Document any conflicts or issues
3. Follow nvf best practices for plugin integration
4. Update this guide with new findings

---

*This integration guide is maintained as part of the GigVim project and reflects best practices for nvf-based Neovim configurations.*