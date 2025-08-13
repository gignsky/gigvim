# Words - Word Highlighting and Navigation

Highlights word occurrences and provides enhanced word-based navigation throughout your codebase.

## Features

- **Word Highlighting**: Automatically highlights all occurrences of the word under cursor
- **Smart Detection**: Context-aware word boundary detection
- **Navigation**: Quick jumping between word occurrences  
- **Visual Feedback**: Clear highlighting to show word locations
- **Performance**: Efficient highlighting without impacting editing speed

## Configuration

```lua
words = { 
  enabled = true,
  debounce = 200, -- delay before highlighting (ms)
  notify_jump = false, -- show notification when jumping
  notify_end = true, -- show notification at end of matches
}
```

## Usage

### Automatic Highlighting
- **Cursor Movement**: When cursor is on a word, all instances highlight automatically
- **Real-time Updates**: Highlighting updates as you move through code
- **Smart Boundaries**: Respects word boundaries (identifiers, strings, etc.)

### Navigation Commands
- `*` - Next occurrence of word under cursor
- `#` - Previous occurrence of word under cursor  
- `n` - Next search result (when using word search)
- `N` - Previous search result (when using word search)

### Manual Commands
- `:SnacksWordsJump` - Jump to next highlighted word
- `:SnacksWordsClear` - Clear all word highlighting
- `:SnacksWordsDisable` - Temporarily disable word highlighting

## Customization

### Highlight Groups
- `SnacksWords` - Default word highlighting
- `SnacksWordsCurrent` - Current word under cursor
- `SnacksWordsMatch` - Matching word occurrences

### Settings
- **Debounce Time**: Adjust delay before highlighting activates
- **File Type Support**: Enable/disable for specific file types
- **Pattern Matching**: Configure word boundary detection
- **Performance**: Limit highlighting in large files

## Benefits

- **Code Reading**: Easily track variable usage throughout files
- **Refactoring**: Quickly identify all locations where identifiers are used
- **Debugging**: Find all references to variables, functions, classes
- **Learning**: Better understand code flow and relationships
- **Navigation**: Faster movement between related code sections

## Integration

Works well with:
- LSP for semantic highlighting
- Search functionality for enhanced navigation
- Telescope for finding references
- Git for tracking changes to highlighted words
- Other snacks plugins for unified experience