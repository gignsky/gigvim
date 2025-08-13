# Advanced Notifier with LSP Progress

Enhanced notification system with advanced LSP progress tracking and beautiful styling.

## Features

- **LSP Progress Integration**: Real-time display of LSP operations (indexing, diagnostics, etc.)
- **Fancy Styling**: Beautiful notification popups with improved visibility
- **Configurable Positioning**: Bottom-up notifications for better workflow
- **Timeout Control**: Customizable display duration (3 seconds default)
- **Multiple Levels**: Support for info, warn, error, and debug notifications

## Configuration

```lua
notifier = { 
  enabled = true,
  timeout = 3000,      -- 3 second timeout
  style = "fancy",     -- Enhanced visual styling
  top_down = false,    -- Show notifications bottom-up
}
```

## Usage

### Manual Notifications
```vim
:lua vim.notify("Message", vim.log.levels.INFO)
:lua vim.notify("Warning", vim.log.levels.WARN)
:lua vim.notify("Error", vim.log.levels.ERROR)
```

### LSP Progress
The notifier automatically displays:
- Language server startup/shutdown
- File indexing progress
- Diagnostic processing
- Code action availability
- Completion engine status

## Visual Features

- **Progress Bars**: Visual progress indicators for long operations
- **Color Coding**: Different colors for different message types
- **Smooth Animations**: Fade in/out effects for notifications
- **Non-Intrusive**: Positioned to not interfere with editing

## Advanced Usage

### Custom Notifications in Lua
```lua
-- Basic notification
require('snacks').notify("Hello World")

-- With level and options
require('snacks').notify("Build Complete", {
  level = vim.log.levels.INFO,
  timeout = 5000,
  title = "Build System"
})
```

### Integration with Other Plugins
The notifier automatically enhances notifications from:
- LSP servers
- Build systems
- Git operations
- Plugin installations
- Error messages

## Tips

- Notifications appear in the bottom-right by default
- LSP progress helps track large file operations
- Use different log levels for better organization
- The fancy style provides better visibility than default notifications