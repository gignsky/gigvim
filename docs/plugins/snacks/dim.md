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

## Customization

Customize dimming behavior:
- Opacity levels
- Scope detection sensitivity
- Animation preferences
- Language-specific settings