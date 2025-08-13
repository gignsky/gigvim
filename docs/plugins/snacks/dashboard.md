# Dashboard - Beautiful Startup Screen

A customizable startup dashboard that appears when opening Neovim without files.

## Features

- **Project Quick Access**: Jump to recent projects and files
- **Git Integration**: Shows Git status and recent commits
- **Customizable Sections**: Add your own shortcuts and information
- **Beautiful Design**: Clean, modern interface
- **Fast Navigation**: Keyboard shortcuts for quick access

## Default Sections

- **Recent Files**: Recently opened files with quick access
- **Projects**: Quick access to project directories
- **Git Status**: Current repository status
- **Shortcuts**: Custom key bindings and commands
- **Footer**: Neovim version and plugin information

## Configuration

```lua
dashboard = { 
  enabled = true,
  sections = {
    { section = "header" },
    { section = "keys",   gap = 1, padding = 1 },
    { section = "startup" },
  }
}
```

## Usage

- **Automatic**: Appears when starting `nvim` without arguments
- **Manual**: `:Dashboard` command to open anytime
- **Navigation**: Use displayed key bindings to navigate
- **Exit**: Press `q` or open any file to close

## Customization

The dashboard can be customized with:
- Custom headers and footers
- Additional shortcuts
- Project-specific information
- Color themes
- Section ordering

## Benefits

- **Quick Project Access**: Faster project switching
- **Visual Overview**: See recent activity at a glance
- **Consistent Experience**: Same interface across projects
- **Productivity**: Reduced time to start working