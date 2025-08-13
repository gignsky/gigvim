# StatusColumn - Enhanced Status Column

Provides an enhanced status column with line numbers, git signs, diagnostics, and fold indicators.

## Features

- **Line Numbers**: Smart line number display with relative/absolute options
- **Git Integration**: Shows git changes (add, modify, delete) in the status column
- **Diagnostic Signs**: LSP diagnostics displayed inline with code
- **Fold Indicators**: Visual indicators for code folding
- **Customizable**: Flexible configuration for different workflows

## Configuration

```lua
statuscolumn = { 
  enabled = true,
  left = { "mark", "sign" }, -- left side of status column
  right = { "fold", "git" }, -- right side of status column
  folds = {
    open = false, -- show open fold icons
    git_hl = false, -- use git highlights for signs
  },
}
```

## Elements

### Line Numbers
- **Absolute**: Standard line numbers (1, 2, 3, ...)
- **Relative**: Relative to current line (0, 1, 2, ...)
- **Hybrid**: Current line absolute, others relative

### Git Signs
- `+` - Added lines
- `~` - Modified lines  
- `-` - Deleted lines
- Git highlights use appropriate colors

### Diagnostic Signs
- `E` - Errors (red)
- `W` - Warnings (yellow)
- `I` - Information (blue)
- `H` - Hints (green)

### Fold Indicators
- `▼` - Open fold
- `▶` - Closed fold
- `│` - Fold continuation

## Customization

You can customize:
- Which elements appear on left vs right
- Colors and highlight groups
- Icons and symbols used
- Git integration behavior
- Fold indicator style

## Usage

- **Automatic**: Status column updates automatically as you edit
- **Click Support**: Mouse clicks on elements trigger actions
- **Git Navigation**: Click git signs to see change details
- **Fold Control**: Click fold indicators to toggle folds

## Benefits

- **Information Dense**: Maximum information in minimal space
- **Visual Feedback**: Immediate feedback on file status
- **Git Awareness**: Quick overview of uncommitted changes
- **Error Tracking**: Easy identification of issues and warnings
- **Code Structure**: Better understanding of code organization through folds