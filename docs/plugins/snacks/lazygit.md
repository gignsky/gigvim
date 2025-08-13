# Lazygit Integration

Snacks.nvim provides seamless integration with Lazygit, a terminal-based Git interface.

## Features

- **Terminal Integration**: Opens Lazygit in a floating terminal window within Neovim
- **Auto Configuration**: Automatically configures Lazygit for optimal Neovim integration
- **Seamless Workflow**: Switch between editing and Git operations without leaving Neovim
- **Custom Keybindings**: Quick access to Git operations

## Usage

### Opening Lazygit
- `:Lazygit` - Opens Lazygit in a floating terminal
- `<leader>gg` - Default keybinding (if configured)

### Features
- Full Lazygit interface within Neovim
- Automatic terminal sizing and positioning
- Integration with Neovim's color scheme
- Proper handling of Git operations

## Configuration

The plugin is configured with:
```lua
lazygit = { 
  enabled = true,
  configure = true,  -- Auto-configure Lazygit for Neovim
}
```

## Dependencies

Requires Lazygit to be installed on your system:
- **macOS**: `brew install lazygit`
- **Ubuntu/Debian**: `sudo apt install lazygit`
- **Arch**: `sudo pacman -S lazygit`
- **Nix**: `nix-env -iA nixpkgs.lazygit`

## Tips

- Use Lazygit's built-in help (`?`) to learn shortcuts
- Configure Lazygit's config file for custom themes and behavior
- Lazygit integrates with your system's Git configuration