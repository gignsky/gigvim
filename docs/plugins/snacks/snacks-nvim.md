# Snacks.nvim - A Collection of Small QoL Plugins

## Implementation

The snacks.nvim plugin has been implemented in `plugins/optional/snacks-nvim.nix` with a comprehensive set of plugins enabled for enhanced Neovim functionality.

### Enabled Plugins

#### 🚀 Core Performance & Usability
- **[bigfile](./bigfile.md)**: Improves performance when opening large files (>1.5MB) by disabling expensive features
- **[quickfile](./quickfile.md)**: Faster file opening when using `nvim somefile.txt` by skipping unnecessary startup hooks

#### 🔔 Enhanced Notifications & LSP Progress  
- **[notifier](./notifier.md)**: Advanced notification system with LSP progress integration, fancy styling, and customizable timeouts

#### 🎯 Git Integration (Priority Features)
- **[lazygit](./lazygit.md)**: Integrated Lazygit terminal interface for advanced Git workflows
- **[git](./git.md)**: Git utilities and enhancements for version control
- **[gitbrowse](./gitbrowse.md)**: Open Git repositories and files in your browser

#### 🎨 UI Enhancements
- **[dashboard](./dashboard.md)**: Beautiful startup dashboard with shortcuts and project info
- **[indent](./indent.md)**: Enhanced indentation guides and scope highlighting
- **[dim](./dim.md)**: Dim inactive code sections for better focus
- **[animate](./animate.md)**: Smooth animations for UI transitions

#### 🛠️ Development Tools
- **[bufdelete](./bufdelete.md)**: Improved buffer deletion that preserves window layout
- **[explorer](./explorer.md)**: Enhanced file explorer with advanced features
- **[input](./input.md)**: Better input dialogs and prompts
- **[picker](./picker.md)**: Advanced file/buffer picker with fuzzy search

#### 🔧 Utilities & Debugging
- **[debug](./debug.md)**: Debugging utilities and helpers
- **[health](./health.md)**: Health check system for Neovim configuration
- **[layout](./layout.md)**: Window layout management and utilities
- **[profiler](./profiler.md)**: Performance profiling tools for Neovim

#### 💻 Terminal & Media
- **[terminal](./terminal.md)**: Enhanced terminal integration
- **[image](./image.md)**: Image viewing support in Neovim

## Testing Instructions

Due to SSL certificate issues in the CI environment when downloading Rust dependencies for blink-cmp, the full build cannot be completed in this environment. However, the implementation can be tested locally:

### Local Testing
1. Build the full configuration: `nix build .#full`
2. Run the built Neovim: `./result/bin/nvim`
3. Verify snacks.nvim is loaded:
   - `:lua print(require('snacks'))` (should return "table: 0x...")
   - `:lua print(vim.inspect(require('snacks').config))` (shows configuration)
   - Generate notifications to test notifier: `:lua vim.notify("Test", vim.log.levels.INFO)`
   - Test quickfile by opening files from command line

### Verification Steps
1. Check if the plugin is loaded: `:lua print(vim.inspect(require('snacks').config))`
2. Verify enabled modules are working:
   - **Bigfile**: Create a test file: `:!head -c 2M /dev/zero > large_test.txt` then open it with `nvim large_test.txt`. You should see "Bigfile detected" message and reduced functionality for better performance.
   - **Notifier**: Run `:lua vim.notify("Hello from Snacks!", vim.log.levels.INFO)` - should show enhanced notification
   - **Quickfile**: Start nvim with a file argument: `nvim flake.nix` should open faster

### Configuration Details
- The plugin is imported in `full.nix` but not in `minimal.nix`
- Uses `extraPlugins` mechanism as specified in the requirements
- Follows the template pattern from other optional plugins
- Source is downloaded from the GitHub repository specified in `flake.nix`

## Next Steps
To extend the configuration, you can add more snacks.nvim plugins by enabling them in the setup call:

```nix
setup = ''
  require('snacks').setup({
    bigfile = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    quickfile = { enabled = true },
    dashboard = { enabled = true },  -- Add dashboard
    indent = { enabled = true },     -- Add indent guides
    -- Add more plugins as needed
  })
'';
```