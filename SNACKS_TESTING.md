# Snacks.nvim Installation and Testing

## Implementation

The snacks.nvim plugin has been implemented in `plugins/optional/snacks-nvim.nix` with the following configuration:

### Basic Setup
```nix
require('snacks').setup({
  -- Basic useful plugins enabled
  bigfile = { enabled = true },
  notifier = { 
    enabled = true,
    timeout = 3000,
  },
  quickfile = { enabled = true },
})
```

### Enabled Plugins

1. **bigfile**: Improves performance when opening large files
2. **notifier**: Enhanced notification system with 3-second timeout
3. **quickfile**: Faster file opening when using `nvim somefile.txt`

## Testing Instructions

Due to SSL certificate issues in the CI environment when downloading Rust dependencies for blink-cmp, the full build cannot be completed in this environment. However, the implementation can be tested locally:

### Local Testing
1. Build the full configuration: `nix build .#full`
2. Run the built Neovim: `./result/bin/nvim`
3. Verify snacks.nvim is loaded:
   - `:lua print(require('snacks'))`
   - Open a large file to test bigfile functionality
   - Generate notifications to test notifier: `:lua vim.notify("Test", vim.log.levels.INFO)`
   - Test quickfile by opening files from command line

### Verification Steps
1. Check if the plugin is loaded: `:lua print(vim.inspect(require('snacks').config))`
2. Verify enabled modules are working:
   - Bigfile: Open a file > 1.5MB
   - Notifier: Run `:lua vim.notify("Hello from Snacks!", vim.log.levels.INFO)`
   - Quickfile: Start nvim with a file argument

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