# Git Utilities

Enhanced Git integration and utilities for better version control workflow.

## Features

- **Git Status Integration**: Real-time Git status in statusline
- **Branch Information**: Current branch and commit information
- **Diff Utilities**: Enhanced diff viewing capabilities
- **Blame Integration**: Git blame information for current line
- **Repository Detection**: Automatic Git repository detection

## Configuration

```lua
git = { 
  enabled = true,
}
```

## Usage

### Lua API
The git module provides functions accessible via Lua:

- `:lua Snacks.git.blame_line()` - Show blame for current line (Keybind: `<leader>gs`)
- `:lua Snacks.git.status()` - Display Git status (Keybind: `<leader>gS`)
- `:lua Snacks.git.branch()` - Show current branch information (Keybind: `<leader>gb`)

### Keybindings
The following keybindings are configured:
- `<leader>gs` - Git blame line
- `<leader>gS` - Git status
- `<leader>gb` - Git branch info
- `<leader>gg` - Open Lazygit
- `<leader>go` - Open in browser (GitBrowse)

### Integration
- Statusline shows Git branch and status
- File explorer shows Git file status
- Buffer indicators for modified files
- Real-time updates on Git operations

## Features

- **File Status Indicators**: See which files are modified, added, or deleted
- **Branch Switching**: Quick branch operations
- **Commit Information**: Access to commit details
- **Integration with Other Tools**: Works with Lazygit and other Git tools

## Benefits

- **Visual Git Status**: Always know your repository state
- **Faster Git Operations**: Quick access to common Git commands
- **Better Workflow**: Seamless integration with editing workflow
- **Real-time Updates**: Immediate feedback on Git operations