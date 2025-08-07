# Snacks.nvim Plugin Documentation for GigVim

## Overview

[Snacks.nvim](https://github.com/folke/snacks.nvim) is a collection of small QoL (Quality of Life) plugins for Neovim developed by Folke Lemaitre. It provides 26+ individual "snacks" (sub-plugins) that enhance the Neovim experience with various utilities, UI improvements, and developer tools.

## Plugin Philosophy

Snacks.nvim follows a modular design philosophy where each feature (snack) can be independently enabled or disabled. This allows users to pick and choose only the functionality they need, keeping the configuration lean and performant.

## Requirements

- **Neovim** >= 0.9.4
- **Optional**: [mini.icons](https://github.com/echasnovski/mini.icons) or [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- **Optional**: A [Nerd Font](https://www.nerdfonts.com/) for proper icon support

## Available Snacks

### Core UI & Interaction

| Snack | Description | Setup Required | External Docs |
|-------|-------------|:--------------:|:-------------:|
| **[animate](https://github.com/folke/snacks.nvim/blob/main/docs/animate.md)** | Efficient animations with 45+ easing functions | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/animate.md) |
| **[input](https://github.com/folke/snacks.nvim/blob/main/docs/input.md)** | Better `vim.ui.input` replacement | ‼️ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/input.md) |
| **[notifier](https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md)** | Pretty `vim.notify` notifications | ‼️ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md) |
| **[picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md)** | Advanced picker for selecting items | ‼️ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md) |
| **[statuscolumn](https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md)** | Enhanced status column | ‼️ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md) |
| **[dashboard](https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md)** | Beautiful declarative dashboards | ‼️ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md) |

### File Management & Navigation

| Snack | Description | Setup Required | External Docs |
|-------|-------------|:--------------:|:-------------:|
| **[explorer](https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md)** | File explorer (picker in disguise) | ‼️ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md) |
| **[bigfile](https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md)** | Handle big files efficiently | ‼️ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md) |
| **[quickfile](https://github.com/folke/snacks.nvim/blob/main/docs/quickfile.md)** | Quick file rendering before plugins load | ‼️ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/quickfile.md) |
| **[bufdelete](https://github.com/folke/snacks.nvim/blob/main/docs/bufdelete.md)** | Delete buffers without disrupting layout | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/bufdelete.md) |
| **[rename](https://github.com/folke/snacks.nvim/blob/main/docs/rename.md)** | LSP-integrated file renaming | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/rename.md) |

### Git Integration

| Snack | Description | Setup Required | External Docs |
|-------|-------------|:--------------:|:-------------:|
| **[git](https://github.com/folke/snacks.nvim/blob/main/docs/git.md)** | Git utilities | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/git.md) |
| **[gitbrowse](https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md)** | Open files/repos in browser (GitHub, GitLab, etc.) | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md) |
| **[lazygit](https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md)** | LazyGit integration with auto-configured colorscheme | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md) |

### Development Tools

| Snack | Description | Setup Required | External Docs |
|-------|-------------|:--------------:|:-------------:|
| **[debug](https://github.com/folke/snacks.nvim/blob/main/docs/debug.md)** | Pretty inspect & backtraces for debugging | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/debug.md) |
| **[profiler](https://github.com/folke/snacks.nvim/blob/main/docs/profiler.md)** | Neovim lua profiler | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/profiler.md) |
| **[terminal](https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md)** | Create and toggle floating/split terminals | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md) |
| **[scratch](https://github.com/folke/snacks.nvim/blob/main/docs/scratch.md)** | Scratch buffers with persistent files | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/scratch.md) |

### Visual Enhancements

| Snack | Description | Setup Required | External Docs |
|-------|-------------|:--------------:|:-------------:|
| **[scope](https://github.com/folke/snacks.nvim/blob/main/docs/scope.md)** | Scope detection and text objects | ‼️ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/scope.md) |
| **[indent](https://github.com/folke/snacks.nvim/blob/main/docs/indent.md)** | Indent guides and scopes | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/indent.md) |
| **[dim](https://github.com/folke/snacks.nvim/blob/main/docs/dim.md)** | Focus by dimming inactive scope | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/dim.md) |
| **[scroll](https://github.com/folke/snacks.nvim/blob/main/docs/scroll.md)** | Smooth scrolling | ‼️ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/scroll.md) |
| **[zen](https://github.com/folke/snacks.nvim/blob/main/docs/zen.md)** | Zen mode for distraction-free coding | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/zen.md) |
| **[image](https://github.com/folke/snacks.nvim/blob/main/docs/image.md)** | Image viewer using Kitty Graphics Protocol | ‼️ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/image.md) |

### Text Processing & LSP

| Snack | Description | Setup Required | External Docs |
|-------|-------------|:--------------:|:-------------:|
| **[words](https://github.com/folke/snacks.nvim/blob/main/docs/words.md)** | Auto-show LSP references and navigation | ‼️ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/words.md) |
| **[notify](https://github.com/folke/snacks.nvim/blob/main/docs/notify.md)** | Utility functions for `vim.notify` | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/notify.md) |

### Utilities & Infrastructure

| Snack | Description | Setup Required | External Docs |
|-------|-------------|:--------------:|:-------------:|
| **[layout](https://github.com/folke/snacks.nvim/blob/main/docs/layout.md)** | Window layout management | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/layout.md) |
| **[toggle](https://github.com/folke/snacks.nvim/blob/main/docs/toggle.md)** | Toggle keymaps with which-key integration | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/toggle.md) |
| **[win](https://github.com/folke/snacks.nvim/blob/main/docs/win.md)** | Create and manage floating windows/splits | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/win.md) |
| **[util](https://github.com/folke/snacks.nvim/blob/main/docs/util.md)** | Utility functions for Snacks _(library)_ | ⚪ | [📖](https://github.com/folke/snacks.nvim/blob/main/docs/util.md) |

**Legend:**
- ‼️ = Requires explicit setup configuration
- ⚪ = Works with minimal or no configuration

## Integration with nvf (NeoVim Flake)

Snacks.nvim presents unique challenges for nvf integration due to its:

1. **Early initialization requirements** (priority = 1000, lazy = false)
2. **Modular architecture** with 26+ individual components
3. **Complex configuration structure** with nested options
4. **Special autocmd setup** that must happen during plugin initialization

### nvf Integration Strategy

Since nvf doesn't natively support snacks.nvim, we use the `extraPlugins` mechanism with special considerations:

1. **Early Setup**: Use `vim.cmd` or init scripts to ensure early initialization
2. **Modular Configuration**: Provide templates for common use cases
3. **Incremental Adoption**: Allow enabling individual snacks as needed
4. **Conflict Resolution**: Handle conflicts with existing nvf plugins

## Key Configuration Principles

### 1. Priority and Lazy Loading
```lua
-- Required for proper initialization
priority = 1000,
lazy = false,
```

### 2. Explicit Enablement
```lua
-- Each snack must be explicitly enabled
opts = {
  bigfile = { enabled = true },
  dashboard = { enabled = true },
  -- ... other snacks
}
```

### 3. Init Function for Early Setup
```lua
init = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      -- Late initialization code
    end,
  })
end,
```

## Health Check

Snacks.nvim provides a health check to verify proper setup:

```vim
:checkhealth snacks
```

## Official Resources

- **Main Repository**: [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- **Documentation**: [docs/](https://github.com/folke/snacks.nvim/tree/main/docs)
- **Examples**: [docs/examples/](https://github.com/folke/snacks.nvim/tree/main/docs/examples)

## GigVim Integration Files

This plugin integration includes:

1. **Main Configuration**: `plugins/optional/snacks-nvim.nix` - Core plugin setup
2. **Template Files**: Individual snack configuration templates
3. **Examples**: Common configuration patterns for nvf
4. **Documentation**: This file and integration guides

## Migration Notes

When adding snacks.nvim to an existing nvf configuration:

1. **Review Conflicts**: Check for plugins that snacks.nvim might replace
2. **Gradual Migration**: Enable snacks one at a time
3. **Test Thoroughly**: Some snacks modify core Neovim behavior
4. **Backup Configuration**: Keep backups of working configurations

## Troubleshooting

### Common Issues

1. **Plugin doesn't load**: Ensure `lazy = false` and `priority = 1000`
2. **Features not working**: Verify explicit `enabled = true` for each snack
3. **Conflicts with other plugins**: Disable conflicting nvf plugins
4. **Performance issues**: Disable unused snacks to improve startup time

### Debug Commands

```vim
:lua print(vim.inspect(require("snacks.config")))
:checkhealth snacks
:Snacks profiler
```

---

*This documentation is maintained as part of the GigVim project and reflects the integration patterns specific to nvf-based Neovim configurations.*