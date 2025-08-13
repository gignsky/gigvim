# Snacks.nvim Health

The health module provides a comprehensive health check system for Neovim configuration, ensuring all components are properly configured and functioning.

## Features

- **Configuration Validation**: Check if all plugins are properly configured
- **Dependency Checking**: Verify external dependencies are available
- **Performance Monitoring**: Monitor system performance and resource usage
- **Issue Detection**: Automatically detect common configuration issues

## Configuration

The health module is enabled by default:

```lua
require('snacks').setup({
  health = { enabled = true }
})
```

## Usage

### Health Check Commands

The primary way to use the health module is through Neovim's built-in health system:

- `:checkhealth` - Run all health checks (includes snacks)
- `:checkhealth snacks` - Run only snacks.nvim health checks
- `:lua Snacks.health.check()` - Programmatic health check

### Lua API

```lua
-- Run health checks programmatically
local health = require('snacks').health
local results = health.check()

-- Check specific module
local snacks_health = health.check_module('snacks')

-- Get health status
local status = health.status()
```

## Health Check Categories

The health module checks:

1. **Core Setup**: Verifies snacks.nvim is properly installed and configured
2. **Module Status**: Checks each enabled snacks module
3. **Dependencies**: Verifies external tools and dependencies
4. **Configuration**: Validates configuration options
5. **Performance**: Monitors resource usage and performance

## Example Output

When running `:checkhealth snacks`, you'll see output like:

```
snacks: health#snacks#check
========================================
  
## Snacks.nvim
  - OK setup called
  
## Snacks.bigfile
  - OK setup {enabled}
  
## Snacks.dashboard  
  - OK setup {enabled}
  - OK setup ran
  - OK dashboard opened
```

## Testing

To verify the health module:

1. Run `:checkhealth snacks` - should show comprehensive health status
2. Check for any ERROR or WARNING messages
3. Verify all enabled modules show as OK

## Benefits

- **Proactive Monitoring**: Catch issues before they become problems
- **Easy Troubleshooting**: Quickly identify configuration problems
- **System Overview**: Get a complete picture of your Neovim setup
- **Performance Insights**: Monitor resource usage and optimization opportunities