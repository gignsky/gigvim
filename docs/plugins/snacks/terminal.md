# Terminal Integration

Enhanced terminal functionality within Neovim with better integration and management.

## Features

- **Floating Terminals**: Beautiful floating terminal windows
- **Terminal Management**: Easy creation and switching between terminals
- **Shell Integration**: Better shell command execution
- **Window Controls**: Resize, move, and manage terminal windows
- **Session Persistence**: Maintain terminal sessions

## Configuration

```lua
terminal = { 
  enabled = true,
  shell = nil,           -- Use default shell
  position = "float",    -- Terminal position
  size = { width = 0.8, height = 0.8 },
}
```

## Usage

### Commands
- `:Terminal` - Open floating terminal
- `:TerminalSplit` - Open terminal in horizontal split
- `:TerminalVsplit` - Open terminal in vertical split
- `:TerminalTab` - Open terminal in new tab

### Navigation
- `<C-\><C-n>` - Exit terminal mode
- `<C-w>` movements work in terminal
- Tab switching between terminals
- Window resizing and movement

## Features

### Terminal Types
- **Floating**: Overlay terminal that doesn't affect layout
- **Split**: Integrated terminal in split windows
- **Tab**: Full-screen terminal in dedicated tab
- **Background**: Hidden terminals that can be recalled

### Shell Integration
- Execute shell commands and see output
- Run build scripts and development tools
- Integration with Git commands
- Support for interactive applications

### Session Management
- Multiple persistent terminal sessions
- Named terminals for different purposes
- Quick switching between terminals
- Session restoration

## Benefits

- **Integrated Workflow**: No need to leave Neovim
- **Better UX**: Floating terminals don't disrupt layout
- **Multi-tasking**: Multiple terminals for different tasks
- **Efficiency**: Quick command execution and result viewing

## Common Use Cases

- **Development**: Running tests, builds, and dev servers
- **Git Operations**: Interactive Git commands
- **System Administration**: System maintenance tasks
- **File Operations**: Complex file manipulations
- **Database Work**: Database CLI interactions

## Integration

Works well with:
- Lazygit for Git operations
- Development tools and build systems
- Language-specific REPLs
- System monitoring tools
- File managers and utilities