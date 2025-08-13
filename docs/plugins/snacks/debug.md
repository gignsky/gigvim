# Snacks.nvim Debug

The debug module provides debugging utilities and helpers for Neovim development and troubleshooting.

## Features

- **Debug Information**: Access detailed information about Neovim's state
- **Performance Monitoring**: Track performance metrics and bottlenecks
- **Plugin Debugging**: Debug plugin interactions and configurations
- **Logging Utilities**: Enhanced logging capabilities for development

## Configuration

The debug module is enabled by default in the snacks.nvim configuration:

```lua
require('snacks').setup({
  debug = { enabled = true }
})
```

## Usage

### Basic Debug Commands

- `:lua Snacks.debug.info()` - Show debug information
- `:lua Snacks.debug.stats()` - Display performance statistics
- `:lua Snacks.debug.log()` - Access debug logs

### Lua API

```lua
-- Get debug information
local debug_info = require('snacks').debug.info()

-- Enable debug logging
require('snacks').debug.enable_logging()

-- Log debug message
require('snacks').debug.log("Debug message", "INFO")
```

## Testing

To verify the debug module is working:

1. Run `:lua print(require('snacks').debug)` - should return a table
2. Execute `:lua Snacks.debug.info()` - should display debug information
3. Check `:checkhealth snacks` for debug module status

## Benefits

- **Development Aid**: Helps debug configuration issues
- **Performance Insights**: Identify performance bottlenecks
- **Troubleshooting**: Quick access to system information
- **Plugin Development**: Useful for developing Neovim plugins