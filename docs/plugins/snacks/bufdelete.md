# Buffer Delete - Smart Buffer Management

Intelligent buffer deletion that preserves window layout and provides better buffer management.

## Features

- **Layout Preservation**: Deletes buffers without closing windows
- **Smart Fallback**: Automatically switches to appropriate alternative buffer
- **Multiple Buffers**: Delete multiple buffers at once
- **Force Delete**: Option to force delete modified buffers
- **Window Management**: Maintains window splits and layout

## Configuration

```lua
bufdelete = { 
  enabled = true,
  confirm = true,        -- Confirm before deleting modified buffers
  force = false,         -- Force delete by default
}
```

## Usage

### Commands
- `:Bdelete` - Delete current buffer, keep window
- `:Bdelete!` - Force delete without confirmation
- `:Bdelete file.txt` - Delete specific buffer
- `:Bwipeout` - Wipeout buffer (remove from memory)

### Multiple Buffers
- `:Bdelete *.log` - Delete all log files
- `:Bdelete 1,3,5` - Delete specific buffer numbers
- `:%Bdelete` - Delete all buffers except current

## Smart Behavior

### Fallback Strategy
When deleting a buffer, automatically switches to:
1. Previous buffer (most recently used)
2. Next buffer in list
3. Empty buffer if no alternatives

### Window Preservation
- Splits remain open with alternative buffer
- Tab layout is maintained
- Window-specific settings preserved

## Benefits

- **Better UX**: No unexpected window closures
- **Efficient Workflow**: Clean buffer management
- **Layout Stability**: Predictable window behavior
- **Flexible Options**: Multiple deletion strategies

## Comparison

| Standard `:bdelete` | Snacks bufdelete |
|-------------------|------------------|
| May close windows | Preserves layout |
| Basic fallback | Smart buffer selection |
| Single buffer focus | Multiple buffer support |
| Manual confirmation | Configurable behavior |