# Upstreaming themery.nvim to nixpkgs

This document outlines the process to upstream `themery.nvim` to nixpkgs, which would allow GigVim to remove the flake input dependency and use the plugin from nixpkgs directly.

## Overview

**themery.nvim** is a theme switcher plugin for Neovim that allows users to change colorschemes on the fly with live preview. Currently, GigVim uses a flake input to fetch this plugin:

```nix
# Current approach in flake.nix
themery-nvim = {
  url = "github:zaldih/themery.nvim";
  flake = false;
};
```

By upstreaming to nixpkgs, we can eliminate this dependency and use:

```nix
# After upstreaming
config.vim.extraPlugins = {
  themery = {
    package = pkgs.vimPlugins.themery-nvim;  # Available from nixpkgs
    setup = ''require('themery').setup({...})'';
  };
};
```

## Why Upstream to nixpkgs?

### Benefits

1. **Removes External Dependencies**: No need for flake input in GigVim
2. **Better Maintenance**: nixpkgs automation handles updates through automated systems that check for upstream releases, update package versions, and run CI tests. As a maintainer, you'll receive GitHub notifications for update PRs but most updates are handled automatically by bots like `r-ryantm`. Manual intervention is typically only needed for breaking changes or build failures.
3. **Wider Availability**: Other Nix users can easily access the plugin
4. **Consistent Versioning**: Follows nixpkgs release cycles
5. **Better Caching**: Available from nixpkgs binary cache

### nixpkgs Maintenance Automation

nixpkgs provides extensive automation for vim plugin maintenance:

**Automated Updates:**
- **r-ryantm bot**: Automatically creates PRs for new upstream releases
- **nixpkgs-update**: Runs weekly to check for plugin updates
- **CI Testing**: Automatic build verification for all supported platforms
- **Vulnerability Scanning**: Security updates are prioritized and automated

**Maintainer Responsibilities:**
- **Minimal Manual Work**: Most updates require no manual intervention
- **Breaking Changes**: Review PRs that fail CI or introduce breaking changes
- **GitHub Notifications**: Receive alerts for update PRs and build failures
- **Periodic Review**: Occasionally verify plugin still works as expected

**Update Process:**
1. Bot detects new upstream release
2. Automatically creates PR with version bump
3. CI runs build and basic functionality tests
4. If tests pass → Auto-merge (for most plugins)
5. If tests fail → Maintainer notification for manual review

**Maintenance Burden**: Very low - typically 1-2 manual interventions per year for most vim plugins.

### Current Plugin Quality Assessment

**themery.nvim** meets nixpkgs quality standards:
- ✅ Pure Lua plugin (no compilation needed)
- ✅ Active development (last updated recently)
- ✅ Good documentation
- ✅ No external dependencies beyond Neovim
- ✅ Clear license (MIT)
- ✅ Stable API

## Step-by-Step Process

### 1. Verify Plugin Requirements

First, ensure the plugin meets nixpkgs standards:

```bash
# Check the plugin repository
git clone https://github.com/zaldih/themery.nvim
cd themery.nvim

# Verify structure
ls -la  # Should have lua/, plugin/, or doc/ directories
cat README.md  # Check documentation quality
cat LICENSE  # Verify license
```

### 2. Add Plugin to vim-plugin-names

The plugin must be added to the list of tracked plugins:

```bash
# Clone nixpkgs
git clone https://github.com/NixOS/nixpkgs
cd nixpkgs

# Edit the plugin names file
vim pkgs/applications/editors/vim/plugins/vim-plugin-names
```

Add this line in alphabetical order:
```
https://github.com/zaldih/themery.nvim,,
```

Format: `<repo_url>,<branch>,<alias>`
- repo_url: The GitHub URL
- branch: Empty for default branch (main/master)
- alias: Empty to use repo name

### 3. Generate Plugin Definitions

Run the plugin update script:

```bash
cd pkgs/applications/editors/vim/plugins

# Update generated plugins
./utils/update.py
```

This will:
- Fetch the latest commit
- Generate entry in `generated.nix`
- Update plugin metadata

### 4. Test the Plugin Locally

Create a test configuration:

```nix
# test-themery.nix
{ pkgs ? import <nixpkgs> {} }:

let
  neovim-with-themery = pkgs.neovim.override {
    vimAlias = true;
    viAlias = true;
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          # Test that themery-nvim builds correctly
          themery-nvim
          # Add some themes to test switching
          catppuccin-nvim
          tokyonight-nvim
        ];
      };
    };
  };
in
neovim-with-themery
```

Test the build:
```bash
nix-build test-themery.nix
```

### 5. Create Pull Request

Prepare the PR following nixpkgs guidelines:

```bash
# Create feature branch
git checkout -b add-themery-nvim

# Stage changes
git add pkgs/applications/editors/vim/plugins/vim-plugin-names
git add pkgs/applications/editors/vim/plugins/generated.nix

# Commit with proper message
git commit -m "vimPlugins.themery-nvim: init"

# Push and create PR
git push origin add-themery-nvim
```

### 6. PR Description Template

```markdown
# vimPlugins.themery-nvim: init

## Description
Add themery.nvim, a Neovim theme switcher plugin with live preview capabilities.

## Metadata
- **Homepage**: https://github.com/zaldih/themery.nvim
- **License**: MIT
- **Language**: Lua
- **Dependencies**: None (pure Lua)

## Testing
- [x] Plugin builds successfully
- [x] No compilation errors
- [x] Plugin loads in Neovim
- [x] Basic functionality works

## Context
This plugin provides theme switching functionality for Neovim users. It supports
live preview and works with most popular colorschemes.

**Semi-automatic update** via vim-plugin-names.
```

## Integration with GigVim

Once the plugin is available in nixpkgs, update GigVim:

### 1. Remove Flake Input

```nix
# In flake.nix - REMOVE this section
themery-nvim = {
  url = "github:zaldih/themery.nvim";
  flake = false;
};
```

### 2. Update Plugin Configuration

```nix
# In plugins/optional/themery-nvim.nix
{ pkgs, ... }:
{
  imports = [ ../../themes ];
  config.vim = {
    extraPlugins = {
      themery = {
        package = pkgs.vimPlugins.themery-nvim;  # Now from nixpkgs
        setup = ''
          require('themery').setup({
            themes = {
              -- Same theme configuration as before
              "catppuccin",
              "tokyonight",
              -- ... rest of themes
            },
            livePreview = true
          })
        '';
      };
    };
  };
}
```

### 3. Update Documentation

```nix
# Update full.nix to remove inputs reference
{ pkgs, ... }:  # Remove inputs parameter
{
  imports = [
    ./minimal.nix
    ./plugins/optional/themery-nvim.nix  # No longer needs inputs
  ];
}
```

## Timeline and Expectations

### Expected Timeline
- **PR Submission**: 1-2 days (preparation)
- **Review Process**: 1-4 weeks (depends on reviewer availability)
- **Merge to nixpkgs**: After approval
- **Available in unstable**: Immediately after merge
- **Available in stable**: Next nixpkgs release (6 months)

### What to Expect
1. **Automated Checks**: nixpkgs CI will test the plugin
2. **Manual Review**: Maintainer will verify the plugin quality
3. **Potential Requests**: May need to address review feedback
4. **Documentation Updates**: Plugin will appear in nixpkgs manual

## Alternative: Manual Package Definition

If the automatic generation doesn't work perfectly, you can create a manual override:

```nix
# In pkgs/applications/editors/vim/plugins/overrides.nix
themery-nvim = buildVimPlugin {
  pname = "themery-nvim";
  version = "2024-01-15";
  src = fetchFromGitHub {
    owner = "zaldih";
    repo = "themery.nvim";
    rev = "commit-hash-here";
    sha256 = "sha256-hash-here";
  };
  meta = with lib; {
    description = "A colorscheme switcher for Neovim with live preview";
    homepage = "https://github.com/zaldih/themery.nvim";
    license = licenses.mit;
    maintainers = with maintainers; [ /* your-github-username */ ];
  };
};
```

## Maintenance Responsibilities

Once upstreamed, nixpkgs will handle:
- ✅ Automatic updates via vim-plugin-names
- ✅ Build system integration
- ✅ Binary cache distribution
- ✅ Security updates
- ✅ Breaking change notifications

You would be responsible for:
- 🔧 Responding to nixpkgs issues if they arise
- 🔧 Helping with any plugin-specific problems
- 🔧 Maintaining the nixpkgs entry if you become a maintainer

## Success Criteria

The upstreaming is successful when:
- [ ] Plugin is available as `pkgs.vimPlugins.themery-nvim`
- [ ] Plugin builds without errors in nixpkgs CI
- [ ] Plugin loads correctly in Neovim
- [ ] GigVim can remove the flake input dependency
- [ ] Users can install the plugin from nixpkgs

## Related Resources

- [nixpkgs Contributing Guide](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md)
- [Vim Plugins in nixpkgs](https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/editors/vim/plugins)
- [vim-plugin-names Format](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/vim-plugin-names)
- [themery.nvim Repository](https://github.com/zaldih/themery.nvim)