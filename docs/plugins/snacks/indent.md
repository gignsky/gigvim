# Enhanced Indentation Guides

Beautiful and functional indentation guides with scope highlighting.

## Features

- **Visual Indentation**: Clear visual guides for code structure
- **Scope Highlighting**: Highlights current scope/block
- **Multiple Languages**: Works with all programming languages
- **Customizable Styling**: Configurable colors and characters
- **Performance Optimized**: Efficient rendering for large files

## Configuration

```lua
indent = { 
  enabled = true,
  char = "│",           -- Character used for guides
  scope_char = "│",     -- Character for scope highlighting
  highlight = true,     -- Enable scope highlighting
}
```

## Visual Features

- **Indent Lines**: Vertical lines showing indentation levels
- **Scope Highlighting**: Current scope is highlighted differently
- **Context Awareness**: Intelligent highlighting based on cursor position
- **Color Coding**: Different colors for different indentation levels

## Language Support

Works with all languages that have proper indentation:
- Python
- JavaScript/TypeScript
- Rust
- Nix
- YAML
- JSON
- And many more

## Benefits

- **Better Code Reading**: Easier to follow code structure
- **Reduced Errors**: Less likely to make indentation mistakes
- **Visual Clarity**: Clear visual hierarchy of code blocks
- **Modern Interface**: Clean, professional appearance

## Customization

You can customize the indent guides with advanced options:

### Rainbow Indent Configuration

For rainbow-colored indent guides (different colors for each level), you can configure highlight groups:

```lua
-- Example advanced configuration
indent = {
  enabled = true,
  scope = {
    enabled = true,
    priority = 200,
    char = "│",
    underline = false,
    only_scope = false,
    only_current = false,
  },
  chunk = {
    enabled = true,
    priority = 200,
    char = {
      corner_top = "┌",
      corner_bottom = "└", 
      horizontal = "─",
      vertical = "│",
      arrow = ">",
    },
  },
  animate = {
    enabled = true,
    style = "out",
    easing = "linear",
    duration = 200,
  },
}
```

### Custom Highlight Groups

You can define custom highlight groups for rainbow colors:

```vim
" Define rainbow colors for indent guides
highlight IndentGuidesOdd  guifg=#ff6b6b guibg=NONE
highlight IndentGuidesEven guifg=#4ecdc4 guibg=NONE
highlight IndentGuides1    guifg=#ff6b6b guibg=NONE
highlight IndentGuides2    guifg=#feca57 guibg=NONE  
highlight IndentGuides3    guifg=#48dbfb guibg=NONE
highlight IndentGuides4    guifg=#ff9ff3 guibg=NONE
highlight IndentGuides5    guifg=#54a0ff guibg=NONE
highlight IndentGuides6    guifg=#5f27cd guibg=NONE
```

### Customization Options:
- **Guide characters**: Change the visual appearance of indent lines
- **Colors and highlighting**: Create rainbow effects or subtle monochrome
- **Scope behavior**: Control how current scope is highlighted  
- **Performance settings**: Optimize for large files
- **Language-specific options**: Different settings per file type
- **Animation**: Smooth transitions when moving between scopes