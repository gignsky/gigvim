# Bigfile Performance Optimization

Automatically optimizes Neovim when opening large files to maintain responsiveness.

## Features

- **Automatic Detection**: Activates for files larger than 1.5MB
- **Performance Optimization**: Disables expensive features for better performance
- **Transparent Operation**: Works automatically without user intervention
- **Customizable Threshold**: File size threshold can be configured

## What Gets Disabled

When bigfile activates, it disables:
- **Treesitter**: Syntax highlighting and parsing
- **LSP**: Language server functionality
- **Syntax Highlighting**: Traditional vim syntax
- **Autocommands**: Many startup and file-type autocommands
- **Plugins**: Expensive file-type specific plugins

## Configuration

```lua
bigfile = { 
  enabled = true,
  size = 1.5 * 1024 * 1024,  -- 1.5MB threshold (customizable)
}
```

## Usage

Bigfile works automatically:
1. Open a large file: `nvim large_log_file.txt`
2. See notification: "Bigfile detected" 
3. Experience faster navigation and editing
4. Features are restored when opening smaller files

## Testing

Create a test file to see bigfile in action:
```bash
# Create a 2MB test file
head -c 2M /dev/zero > large_test.txt

# Open with nvim
nvim large_test.txt
```

You should see reduced functionality but much better performance.

## Benefits

- **Faster File Opening**: Large files open quickly
- **Responsive Scrolling**: Smooth navigation through large files
- **Reduced Memory Usage**: Lower memory consumption
- **Better User Experience**: No freezing on large files

## Common Use Cases

- Log files
- Data files (CSV, JSON)
- Minified code
- Generated files
- Database dumps