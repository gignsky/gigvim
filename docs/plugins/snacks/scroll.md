# Scroll - Smooth Scrolling Enhancement

Provides smooth scrolling animations and enhanced scroll behavior for better navigation experience.

## Features

- **Smooth Animation**: Fluid scrolling transitions instead of jumpy movement
- **Configurable Speed**: Adjustable animation duration and easing
- **Smart Scrolling**: Context-aware scrolling behavior
- **Performance Optimized**: Efficient animations that don't impact editing performance

## Configuration

```lua
scroll = { 
  enabled = true,
  animate = {
    duration = 250,
    easing = "outQuad",
  },
  spamming = 10, -- threshold for detecting scroll spamming
}
```

## Usage

- **Automatic**: All scrolling operations use smooth animations
- **Keyboard Navigation**: `j`, `k`, `<C-u>`, `<C-d>`, etc. use smooth scrolling
- **Mouse Scrolling**: Wheel scrolling includes smooth animations
- **Jump Commands**: `gg`, `G`, search results, etc. animate smoothly

## Scroll Commands

Common scrolling operations enhanced:
- `<C-u>` / `<C-d>` - Half page up/down with animation
- `<C-b>` / `<C-f>` - Full page up/down with animation
- `gg` / `G` - Jump to top/bottom with smooth transition
- `n` / `N` - Search result navigation with animation

## Customization

Available easing options:
- `linear` - Constant speed
- `ease`, `easeIn`, `easeOut`, `easeInOut` - Standard curves
- `outQuad`, `inQuad` - Quadratic curves
- `circIn`, `circOut`, `circInOut` - Circular motion
- `backIn`, `backOut`, `backInOut` - Overshooting animations

## Performance

- **Spam Detection**: Prevents performance issues during rapid scrolling
- **Frame Rate**: Maintains 60fps animations when possible
- **CPU Efficient**: Minimal impact on system resources
- **Memory Safe**: No memory leaks from animation callbacks

## Benefits

- **User Experience**: Smoother, more pleasant editing experience
- **Visual Comfort**: Reduces eye strain from jerky movements
- **Professional Feel**: Modern, polished interface behavior
- **Focus Retention**: Easier to track cursor position during navigation