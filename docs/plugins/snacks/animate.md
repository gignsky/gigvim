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

## Customization

Customize animation behavior:
- Duration and speed
- Easing functions
- Which elements to animate
- Performance settings