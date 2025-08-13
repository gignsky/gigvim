# Themery.nvim - Theme Management Plugin

Themery.nvim is a theme management plugin that provides a simple interface for switching between different Neovim colorschemes and managing theme configurations.

## Features

- **Theme Switching**: Easy switching between multiple colorschemes
- **Theme Persistence**: Remember selected theme across sessions
- **Theme Preview**: Preview themes before applying them
- **Custom Theme Lists**: Define custom lists of favorite themes
- **Integration**: Works with any Neovim-compatible colorscheme

## Installation Status

Themery.nvim is available as an optional plugin in GigVim and can be enabled in the configuration.

## Configuration

Themery can be configured in your plugin configuration:

```nix
# Add to your plugins configuration
themery = {
  enable = true;
  themes = [
    "catppuccin"
    "tokyonight"
    "gruvbox"
    "onedark"
    "nord"
  ];
  defaultTheme = "catppuccin";
  persistence = true;
};
```

## Usage

### Basic Commands

- `:Themery` - Open theme selector
- `:ThemeryToggle` - Toggle between light/dark variants
- `:ThemeryReset` - Reset to default theme
- `:ThemeryList` - List all available themes

### Theme Selection Interface

When you run `:Themery`, you'll see an interactive interface with:
- List of available themes
- Preview of each theme
- Current theme indicator
- Search/filter functionality

### Lua API

```lua
-- Switch to specific theme
require('themery').set_theme('catppuccin')

-- Get current theme
local current = require('themery').get_current()

-- List available themes
local themes = require('themery').get_themes()

-- Toggle theme variant
require('themery').toggle_variant()
```

## Theme Management

### Adding New Themes

To add new themes to your themery configuration:

1. Install the colorscheme plugin
2. Add it to your themery themes list
3. Restart Neovim or reload configuration

### Custom Theme Groups

Organize themes into groups:

```lua
require('themery').setup({
  themes = {
    {
      name = "Dark Themes",
      themes = { "catppuccin", "tokyonight", "onedark" }
    },
    {
      name = "Light Themes", 
      themes = { "catppuccin-latte", "github-light" }
    }
  }
})
```

### Theme Persistence

Themery can remember your theme choice:
- Saves theme preference to file
- Restores theme on startup
- Syncs across Neovim instances

## Integration with GigVim

In GigVim, themery works alongside:
- **Catppuccin themes**: Multiple variants available
- **nvf theme system**: Integrates with nvf's theme management
- **LSP integration**: Themes work with all LSP highlighting
- **Treesitter**: Full syntax highlighting support

## Key Bindings

Suggested keybindings for themery:

```nix
# Add to your keybindings
{
  key = "<leader>th";
  mode = "n";
  action = ":Themery<CR>";
  desc = "Open Theme Selector";
}
{
  key = "<leader>tt";
  mode = "n"; 
  action = ":ThemeryToggle<CR>";
  desc = "Toggle Theme Variant";
}
```

## Available Themes in GigVim

GigVim comes with several pre-configured themes:
- **Catppuccin variants**: Mocha, Macchiato, Frappe, Latte
- **Additional themes**: Can be added through plugin configuration

## Testing

To verify themery is working:

1. Run `:Themery` - should open theme selector
2. Try switching themes from the interface
3. Restart Neovim and verify theme persistence
4. Test theme variants with `:ThemeryToggle`

## Customization

### Custom Theme Configuration

```lua
require('themery').setup({
  -- Custom theme definitions
  themes = {
    {
      name = "Catppuccin Mocha",
      colorscheme = "catppuccin-mocha",
      before = function()
        -- Setup before theme loads
      end,
      after = function()
        -- Custom highlights after theme loads
      end
    }
  },
  
  -- UI customization
  themeConfigFile = vim.fn.stdpath("config") .. "/lua/settings/theme.lua",
  livePreview = true,
})
```

## Benefits

- **Productivity**: Quick theme switching for different lighting conditions
- **Personalization**: Easy customization of your Neovim appearance
- **Organization**: Manage multiple themes efficiently  
- **Consistency**: Maintain theme preferences across sessions
- **Exploration**: Easily try new themes without commitment

## Troubleshooting

Common issues and solutions:

1. **Theme not loading**: Ensure colorscheme plugin is installed
2. **Persistence not working**: Check file permissions in config directory
3. **Preview not working**: Verify theme files are accessible
4. **Key conflicts**: Check for conflicting keybindings

## Performance

Themery is lightweight and has minimal impact on startup time:
- Lazy loading of theme files
- Efficient theme caching
- Fast theme switching
- Low memory footprint