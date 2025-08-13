# Scope - Enhanced Scope Highlighting

Provides advanced scope highlighting and management for better code visibility and navigation.

## Features

- **Visual Scope Indicators**: Clear visual indication of current scope
- **Multi-level Highlighting**: Different colors for nested scopes
- **Smart Detection**: Automatic scope boundary detection
- **Language Support**: Works with multiple programming languages via treesitter

## Configuration

```lua
scope = { 
  enabled = true,
  priority = 200,
  animate = {
    enabled = true,
    duration = 200,
  },
}
```

## Usage

- **Automatic**: Scope highlighting activates automatically when navigating code
- **Manual Commands**: `:SnacksScope` to toggle scope highlighting
- **Visual Feedback**: Current scope boundaries are highlighted in real-time

## Customization

The scope plugin can be customized with:
- Different highlight colors for various scope levels
- Animation settings for smooth transitions
- Language-specific scope detection rules
- Priority settings for highlight precedence

## Benefits

- **Code Navigation**: Easier to understand code structure
- **Debugging**: Quickly identify scope boundaries
- **Code Review**: Better visual structure for reviewing nested code
- **Learning**: Helps understand programming language scope rules

## Integration

Works seamlessly with:
- Treesitter for syntax parsing
- Indent guides for visual consistency
- LSP for semantic understanding
- Other snacks plugins for unified experience