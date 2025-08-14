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
- **LSP**: Language server functionality (detached from buffer)
- **Syntax Highlighting**: Traditional vim syntax (basic fallback enabled)
- **Autocommands**: Many startup and file-type autocommands
- **Plugins**: Expensive file-type specific plugins
- **Animations**: All snacks.nvim animations (window, scroll, indent, dim, scope)
- **Indent Guides**: Complex indentation visualization
- **Word Highlighting**: Document word highlighting
- **Scope Highlighting**: Current scope visualization
- **Parentheses Matching**: Complex bracket matching
- **Semantic Tokens**: LSP-based semantic highlighting
- **Status Column**: Advanced status column features

## Configuration

```lua
bigfile = { 
  enabled = true,
  notify = true, -- Show notification when big file detected
  size = 1.5 * 1024 * 1024,  -- 1.5MB threshold (customizable)
  line_length = 1000, -- Average line length for minified files
  -- Custom setup function to optimize performance
  setup = function(ctx)
    -- Disable performance-heavy features
    -- (handled automatically by GigVim configuration)
  end,
}
```

The enhanced configuration automatically disables:
- All animations (window, scroll, indent, dim, scope)
- Indent guides and complex visualizations
- Word and scope highlighting
- Parentheses matching
- LSP attachment and semantic tokens
- Advanced status column features
- Sets manual folding and basic syntax highlighting

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
- **Large repositories** (e.g., nixpkgs files)
- **Lock files** (package-lock.json, flake.lock)
- **Compiled output** (bundled JavaScript, etc.)

## Working with Large Repositories

When working with large repositories like nixpkgs, bigfile optimization helps by:

1. **Faster file navigation**: No LSP overhead when browsing large files
2. **Reduced memory usage**: Animations and visual features disabled
3. **Responsive editing**: Core editing functions remain fast
4. **Automatic activation**: Works transparently for files >1.5MB

**Note**: While nvf doesn't support lazy loading like lazy.nvim, the bigfile plugin provides effective performance optimization by selectively disabling expensive features per buffer.