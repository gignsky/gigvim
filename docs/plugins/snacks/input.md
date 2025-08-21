# Enhanced Input - Better Input dialogues

Improved input dialogues and prompts with better UX and functionality.

## Features

- **Better Styling**: Enhanced visual appearance for input dialogues
- **Input Validation**: Real-time validation of user input
- **History Support**: Access to previous inputs
- **Completion**: Auto-completion for common inputs
- **Multi-line Support**: Support for multi-line text input

## Configuration

```lua
input = { 
  enabled = true,
  position = "center",    -- Dialog position
  size = { width = 60, height = 1 },
  border = "rounded",     -- Border style
}
```

## Features

### Enhanced dialogues

- File rename operations
- Search and replace prompts
- Custom command inputs
- Plugin configuration dialogues

### Input Types

- **Single Line**: Standard text input
- **Multi-line**: Text areas for longer content
- **Passwords**: Hidden character input
- **Numbers**: Numeric input with validation
- **Selections**: Dropdown-style selections

### Validation

- Real-time input checking
- Error highlighting
- Helpful error messages
- Format suggestions

## Usage

The enhanced input automatically replaces standard Neovim input prompts:

- Rename files in explorer
- Search/replace operations
- Command palette inputs
- Plugin configuration prompts

### Example Interactions

- File operations show better-styled dialogues
- LSP rename operations use enhanced prompts
- Search operations have improved UX
- Configuration changes use better input forms

## Benefits

- **Better UX**: More intuitive input experience
- **Visual Appeal**: Modern, clean interface
- **Reduced Errors**: Input validation prevents mistakes
- **Efficiency**: Faster input with completion and history
- **Consistency**: Uniform input experience across plugins

## Integration

Works seamlessly with:

- File managers and explorers
- LSP operations (rename, etc.)
- Search and replace functions
- Custom commands and plugins
- Configuration interfaces

