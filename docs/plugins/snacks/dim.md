# Dim - Focus Enhancement

Dims inactive code sections to improve focus and reduce visual clutter.

## Features

- **Scope Dimming**: Dims code outside current scope/function
- **Configurable Opacity**: Adjustable dimming levels
- **Language Aware**: Works with different programming languages
- **Real-time Updates**: Dynamic dimming as cursor moves
- **Visual Focus**: Highlights active code sections

## Configuration

```lua
dim = { 
  enabled = true,
  scope = {
    enabled = true,      -- Enable scope-based dimming
    min_size = 5,        -- Minimum scope size to dim
  },
  animate = {
    enabled = true,      -- Smooth transitions
    duration = 200,      -- Animation duration
  }
}
```

## How It Works

### Scope Detection
- Automatically detects code scopes (functions, classes, blocks)
- Uses treesitter for accurate scope identification
- Supports multiple languages and syntax structures
- Adapts to different indentation styles

### Dimming Behavior
- **Active Scope**: Current function/class remains normal brightness
- **Inactive Scopes**: Other functions/classes are dimmed
- **Context Lines**: Some surrounding lines remain visible
- **Cursor Movement**: Dimming updates as you navigate

## Visual Effects

### Dimming Levels
- **Subtle**: Light dimming for minimal distraction
- **Medium**: Balanced dimming for clear focus
- **Strong**: Heavy dimming for maximum focus

### Animations
- Smooth transitions between active/inactive states
- Configurable animation speed
- No jarring changes when moving cursor

## Benefits

- **Improved Focus**: Easier to concentrate on current code
- **Reduced Clutter**: Less visual noise from inactive code
- **Better Reading**: Clearer code structure understanding
- **Modern Interface**: Professional, polished appearance

## Language Support

Works with languages that have good treesitter support:
- Python, JavaScript, TypeScript
- Rust, Go, C/C++
- Nix, Lua, JSON
- And many more

## Use Cases

- **Large Files**: Navigate complex files more easily
- **Code Review**: Focus on specific functions/sections
- **Learning**: Understand code structure better
- **Debugging**: Isolate problem areas visually

## Testing and Troubleshooting

### Verification Steps
1. **Check if enabled**: `:lua print(require('snacks').config.dim.enabled)`
2. **Test with code file**: Open a large code file (like a Nix configuration)
3. **Move cursor**: Navigate between functions - should see dimming effects
4. **Check treesitter**: `:lua print(vim.treesitter.get_parser():lang())` - should show language parser

### Expected Behavior
- When cursor is in a function, other functions should appear dimmed
- Moving between functions should smoothly transition dimming
- Small scopes (< min_size) should not be dimmed
- Animation should be smooth, not jarring

### Troubleshooting
If dimming is not working:

1. **Check treesitter support**: Dim requires treesitter for scope detection
   ```lua
   -- Verify treesitter is available for current file
   :lua print(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()])
   ```

2. **Verify configuration**: 
   ```lua
   -- Check dim configuration
   :lua print(vim.inspect(require('snacks').config.dim))
   ```

3. **Test file requirements**:
   - File must be large enough (> min_size lines in scopes)
   - Must have clear function/class definitions
   - Language must have treesitter parser installed

4. **Check health**: `:checkhealth snacks` should show dim status

### Configuration Troubleshooting
If dim seems too subtle or too strong:

```lua
-- More aggressive dimming
dim = {
  enabled = true,
  scope = {
    min_size = 3,        -- Lower threshold
    max_size = 30,       -- Higher threshold  
    siblings = true,     -- Dim sibling scopes
  },
  animate = {
    enabled = true,
    easing = "outQuad",
    duration = 300,      -- Slower animation
  },
}
```

### Manual Testing
```lua
-- Toggle dim manually to see effect
:lua require('snacks').dim.toggle()

-- Force refresh dimming
:lua require('snacks').dim.update()
```