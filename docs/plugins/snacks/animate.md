# Animate - Smooth UI Transitions

Beautiful animations for Neovim UI elements and transitions.

## Features

- **Window Animations**: Smooth opening/closing of windows
- **Cursor Animations**: Animated cursor movements
- **Scroll Animations**: Smooth scrolling transitions
- **Popup Animations**: Animated popups and notifications
- **Customizable Easing**: Different animation curves and speeds

## Configuration

```lua
animate = { 
  enabled = true,
  duration = 100,        -- Animation duration in ms
  easing = "ease-out",   -- Animation easing function
  fps = 60,              -- Frames per second
}
```

## Animation Types

### Window Animations
- Window opening/closing
- Split creation/destruction
- Tab switching
- Buffer switching

### Cursor Animations
- Jump to line animations
- Search result highlighting
- Mark jumping
- Tag navigation

### Scroll Animations
- Page up/down
- Half-page scrolling
- Goto line
- Search navigation

## Benefits

- **Visual Appeal**: More polished and modern interface
- **Better UX**: Smoother transitions reduce jarring changes
- **Focus Tracking**: Easier to follow cursor and window changes
- **Professional Feel**: More refined editing experience

## Performance

- **Optimized Rendering**: Efficient animation algorithms
- **Configurable Speed**: Adjust performance vs. visual quality
- **Disable Options**: Can be disabled for performance
- **Smart Activation**: Only animates when beneficial

## Testing and Verification

To verify the animate module is working properly:

### Visual Tests
1. **Window Operations**: Open and close splits (`<C-w>s`, `<C-w>q`) - should see smooth transitions
2. **Tab Switching**: Create multiple tabs and switch between them - should see smooth tab transitions
3. **Buffer Switching**: Switch between buffers - should see smooth content transitions
4. **Popup Animations**: Open completion menus or notifications - should see smooth popup animations

### Specific Test Commands
```lua
-- Test window animations
:split
:close

-- Test cursor animations (jump to line)
:100
:1

-- Test scroll animations
<C-f>  -- Page down
<C-b>  -- Page up

-- Test search animations
/pattern<Enter>
n  -- Next match
```

### Configuration Verification
```lua
-- Check if animate is loaded and configured
:lua print(vim.inspect(require('snacks').animate))

-- Verify animation settings
:lua print(require('snacks').config.animate)
```

### Expected Behavior
- Window opens/closes should have smooth fade or slide effects
- Cursor jumps should be animated rather than instant
- Scrolling should be smooth rather than jarring
- Popups should appear with gentle transitions

### Troubleshooting
If animations aren't visible:
1. Check if your terminal supports smooth rendering
2. Verify configuration is loaded: `:checkhealth snacks`
3. Try adjusting fps or duration settings
4. Ensure terminal refresh rate is adequate