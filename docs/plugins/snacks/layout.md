# Snacks.nvim Layout

The layout module provides advanced window layout management and utilities for organizing your Neovim workspace efficiently.

## Features

- **Window Management**: Advanced window creation and organization
- **Layout Presets**: Pre-configured layouts for common workflows  
- **Dynamic Resizing**: Intelligent window resizing and positioning
- **Session Integration**: Save and restore window layouts
- **Multi-tab Support**: Layout management across multiple tabs

## Configuration

The layout module is enabled by default:

```lua
require('snacks').setup({
  layout = { enabled = true }
})
```

### Advanced Configuration

```lua
layout = {
  enabled = true,
  preset = {
    -- Common layout presets
    ide = {
      { type = "split", direction = "horizontal", size = 0.8 },
      { type = "explorer", side = "left", size = 30 },
      { type = "terminal", side = "bottom", size = 15 }
    }
  }
}
```

## Usage

### Basic Layout Commands

- `:lua Snacks.layout.preset('ide')` - Apply IDE layout preset
- `:lua Snacks.layout.save('custom')` - Save current layout
- `:lua Snacks.layout.load('custom')` - Load saved layout
- `:lua Snacks.layout.reset()` - Reset to default layout

### Lua API

```lua
local layout = require('snacks').layout

-- Create custom layout
layout.create({
  explorer = { side = "left", size = 30 },
  terminal = { side = "bottom", size = 15 },
  main = { type = "editor" }
})

-- Manage windows
layout.toggle_explorer()
layout.toggle_terminal()
layout.focus_main()

-- Save/restore
layout.save_session()
layout.restore_session()
```

## Layout Presets

### IDE Layout
- File explorer on the left
- Main editor in the center
- Terminal at the bottom
- Symbol outline on the right

### Focus Layout  
- Minimal distractions
- Single main window
- Hidden sidebars

### Debug Layout
- Debug console
- Variables panel
- Watch panel
- Main editor

## Window Management

### Smart Resizing
The layout module provides intelligent window resizing:
- Maintains aspect ratios
- Respects minimum sizes
- Adapts to terminal size changes

### Focus Management
- Automatic focus switching
- Smart cursor positioning
- Context-aware navigation

## Testing

To verify the layout module:

1. Run `:lua print(require('snacks').layout)` - should return a table
2. Try creating a layout: `:lua Snacks.layout.preset('ide')`
3. Test window management functions
4. Check `:checkhealth snacks` for layout module status

## Benefits

- **Productivity**: Organized workspace improves efficiency
- **Consistency**: Reproducible layouts across sessions
- **Flexibility**: Customizable for different workflows
- **Automation**: Automatic layout management
- **Multi-monitor**: Support for multiple monitor setups