# Explorer - Enhanced File Browser

Advanced file explorer with modern features and intuitive interface.

## Features

- **Tree View**: Hierarchical file and directory display
- **Git Integration**: Shows Git status for files and directories
- **Quick Actions**: Rename, delete, create files and directories
- **Search Integration**: Find files quickly within the explorer
- **Customizable Interface**: Configurable icons, colors, and layout

## Configuration

```lua
explorer = { 
  enabled = true,
  width = 30,           -- Explorer window width
  side = "left",        -- Position (left/right)
  auto_close = false,   -- Auto-close when opening files
}
```

## Usage

### Commands
- `:Explorer` - Toggle file explorer
- `:ExplorerFocus` - Focus on explorer window
- `<leader>e` - Default toggle keybinding (if configured)

### Navigation
- `j/k` - Move up/down
- `l` or `Enter` - Open file/expand directory
- `h` - Collapse directory or go to parent
- `o` - Open file in new split

### File Operations
- `a` - Create new file
- `A` - Create new directory
- `r` - Rename file/directory
- `d` - Delete file/directory
- `x` - Cut file
- `c` - Copy file
- `p` - Paste file

## Features

- **Git Status Icons**: See file modifications at a glance
- **File Type Icons**: Visual file type indicators
- **Hidden File Toggle**: Show/hide hidden files
- **Bookmark Support**: Quick access to frequently used directories
- **Search Integration**: Filter files as you type

## Benefits

- **Efficient Navigation**: Quick file and directory access
- **Visual Organization**: Clear project structure overview
- **Integrated Workflow**: Seamless integration with editing
- **Modern Interface**: Clean, intuitive design