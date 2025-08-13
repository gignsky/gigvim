# Advanced Picker - File and Buffer Selection

Fast, fuzzy-finding picker for files, buffers, and more with advanced filtering.

## Features

- **Fuzzy Search**: Intelligent fuzzy matching for quick file finding
- **Multiple Sources**: Files, buffers, Git files, symbols, and more
- **Preview Window**: Live preview of selected items
- **Custom Actions**: Multiple actions for each picker type
- **Fast Performance**: Optimized for large projects

## Configuration

```lua
picker = { 
  enabled = true,
  layout = "vertical",    -- Layout style
  preview = true,         -- Enable preview window
  hidden = false,         -- Show hidden files
}
```

## Usage

### Commands
- `:Pick files` - Find files in current directory
- `:Pick buffers` - Switch between open buffers
- `:Pick git_files` - Find files tracked by Git
- `:Pick grep` - Search text in files
- `:Pick symbols` - Find symbols in current file

### Navigation
- `Ctrl-j/k` - Move up/down in results
- `Ctrl-n/p` - Alternative navigation
- `Enter` - Select item
- `Ctrl-x` - Open in horizontal split
- `Ctrl-v` - Open in vertical split

## Picker Types

### File Pickers
- **Files**: All files in project
- **Git Files**: Only Git-tracked files
- **Recent Files**: Recently opened files
- **Find Files**: Files matching pattern

### Content Pickers
- **Grep**: Search text across files
- **Live Grep**: Real-time text search
- **Symbols**: Function/class/variable symbols
- **References**: Symbol references

### Buffer Pickers
- **Buffers**: Open buffers
- **Recent Buffers**: Recently used buffers
- **Modified Buffers**: Buffers with unsaved changes

## Benefits

- **Fast File Access**: Quickly find and open any file
- **Efficient Workflow**: Reduce time spent navigating
- **Visual Feedback**: Preview before opening
- **Flexible Interface**: Multiple ways to interact with results