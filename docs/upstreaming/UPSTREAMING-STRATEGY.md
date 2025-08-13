# Upstreaming Strategy: Removing Flake Input Dependencies

This document provides a comprehensive strategy for upstreaming the `themery.nvim` plugin used in GigVim to eliminate the external flake input dependency. It compares both approaches and provides actionable next steps.

## Current Situation

GigVim currently uses themery.nvim via a flake input:

```nix
# flake.nix
inputs = {
  # ... other inputs
  themery-nvim = {
    url = "github:zaldih/themery.nvim";
    flake = false;
  };
};

# plugins/optional/themery-nvim.nix  
{ inputs, pkgs, ... }:
let
  themery-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "themery-nvim";
    src = inputs.themery-nvim;
  };
in {
  config.vim.extraPlugins.themery = {
    package = themery-from-source;
    setup = ''require('themery').setup({...})'';
  };
}
```

**Problems with current approach:**
- 🔴 External dependency increases build complexity
- 🔴 Slower builds (must fetch from GitHub each time)
- 🔴 Potential for broken builds if upstream changes
- 🔴 Not available to other Nix users
- 🔴 Manual maintenance required

## Two Upstreaming Approaches

### Option 1: Upstream to nixpkgs ⭐ **RECOMMENDED**

**What:** Add themery.nvim to nixpkgs vim-plugins

**Benefits:**
- ✅ **Immediate impact**: Removes flake input dependency
- ✅ **Wide availability**: All Nix users can use the plugin
- ✅ **Automatic updates**: nixpkgs automation handles maintenance
- ✅ **Binary caching**: Faster installations for everyone
- ✅ **Lower maintenance**: nixpkgs team handles updates
- ✅ **Simpler implementation**: Just add to plugin list

**Effort:** Low (2-4 hours)
**Timeline:** 2-6 weeks (PR review process)
**Risk:** Low (well-established process)

### Option 2: Create nvf Module

**What:** Create a built-in nvf module for themery

**Benefits:**
- ✅ **Type-safe configuration**: Better user experience
- ✅ **Deep integration**: Works with nvf's theme system
- ✅ **Auto-documentation**: Generated option docs
- ✅ **Better defaults**: nvf-specific optimizations

**Drawbacks:**
- ❌ **Higher effort**: More complex implementation
- ❌ **Slower adoption**: Must be merged into nvf
- ❌ **Single ecosystem**: Only benefits nvf users
- ❌ **Ongoing maintenance**: Part of nvf codebase

**Effort:** Medium (8-12 hours)
**Timeline:** 4-12 weeks (nvf review process)
**Risk:** Medium (depends on nvf maintainer availability)

## Recommended Strategy: Dual Approach

### Phase 1: nixpkgs Upstream (Priority 1) 🎯

**Immediate action** to remove the flake dependency:

1. **Week 1-2**: Submit themery.nvim to nixpkgs
2. **Week 2-6**: Wait for review and merge
3. **Week 6+**: Update GigVim to use nixpkgs version

**Result:** Eliminates flake input, available to all Nix users

### Phase 2: nvf Module (Optional) 🚀

**Future enhancement** for better user experience:

1. **After Phase 1**: Create nvf module using nixpkgs package
2. **Long-term**: Provide type-safe configuration options

**Result:** Better UX while maintaining nixpkgs availability

## Implementation Plan

### Phase 1: nixpkgs Submission

#### Step 1: Prepare nixpkgs PR (1-2 hours)

```bash
# 1. Clone nixpkgs
git clone https://github.com/NixOS/nixpkgs
cd nixpkgs
git checkout -b add-themery-nvim

# 2. Add to vim-plugin-names
echo "https://github.com/zaldih/themery.nvim,," >> pkgs/applications/editors/vim/plugins/vim-plugin-names
sort -o pkgs/applications/editors/vim/plugins/vim-plugin-names pkgs/applications/editors/vim/plugins/vim-plugin-names

# 3. Generate plugin definition
cd pkgs/applications/editors/vim/plugins
./utils/update.py

# 4. Test the build
nix-build -A vimPlugins.themery-nvim

# 5. Commit and push
git add vim-plugin-names generated.nix
git commit -m "vimPlugins.themery-nvim: init"
git push origin add-themery-nvim
```

#### Step 2: Submit PR (30 minutes)

Create PR with this description:

```markdown
# vimPlugins.themery-nvim: init

Add themery.nvim, a Neovim colorscheme switcher with live preview.

## Details
- **Homepage**: https://github.com/zaldih/themery.nvim  
- **License**: MIT
- **Language**: Pure Lua (no compilation needed)
- **Dependencies**: None

## Testing
- [x] Plugin builds successfully
- [x] No build errors or warnings
- [x] Plugin loads correctly in Neovim

Semi-automatic update via vim-plugin-names.
```

#### Step 3: Wait for merge (2-6 weeks)

Monitor the PR and respond to any reviewer feedback.

### Phase 2: Update GigVim

#### After nixpkgs merge:

```bash
# 1. Remove flake input
# Edit flake.nix and remove themery-nvim input

# 2. Update plugin configuration
# Edit plugins/optional/themery-nvim.nix
```

```nix
# New implementation without flake input
{ pkgs, ... }:
{
  imports = [ ../../themes ];
  config.vim = {
    extraPlugins = {
      themery = {
        package = pkgs.vimPlugins.themery-nvim;  # From nixpkgs!
        setup = ''
          require('themery').setup({
            themes = {
              -- Same configuration as before
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

```nix
# Update full.nix
{ pkgs, ... }:  # Remove inputs parameter
{
  imports = [
    ./minimal.nix
    ./plugins/optional/themery-nvim.nix  # No inputs needed
  ];
}
```

#### Test the changes:

```bash
# Verify builds work without flake input
nix flake check
nix build .#default

# Test that themery still works
./result/bin/nvim
# In nvim: :Themery
```

## Migration Validation Checklist

### Before Migration
- [ ] Current setup builds successfully
- [ ] Themery plugin loads and works
- [ ] All themes are accessible
- [ ] Configuration is properly applied

### After nixpkgs Merge
- [ ] Plugin available as `pkgs.vimPlugins.themery-nvim`
- [ ] Plugin builds in nixpkgs CI
- [ ] No build errors or warnings

### After GigVim Update  
- [ ] Flake input completely removed
- [ ] GigVim builds without external dependency
- [ ] Themery functionality unchanged
- [ ] All tests pass
- [ ] Documentation updated

## Risk Mitigation

### Risk: nixpkgs PR gets stuck
**Mitigation:** 
- Follow up weekly on PR status
- Engage with vim plugin maintainers
- Consider manual package definition if needed

### Risk: Breaking changes in upstream
**Mitigation:**
- Pin to specific commit hash in nixpkgs
- Test thoroughly before updating
- Monitor upstream for breaking changes

### Risk: Build failures
**Mitigation:**
- Test locally before submitting
- Use nixpkgs CI to validate
- Have rollback plan ready

## Timeline and Milestones

### Week 1-2: Preparation
- [ ] Fork nixpkgs repository
- [ ] Add themery.nvim to vim-plugin-names
- [ ] Test plugin builds locally
- [ ] Submit PR to nixpkgs

### Week 2-6: Review Period
- [ ] Monitor PR for reviewer feedback
- [ ] Make any requested changes
- [ ] Ensure CI passes
- [ ] Plugin gets merged to nixpkgs

### Week 6+: Integration
- [ ] Update GigVim flake.nix
- [ ] Update themery plugin configuration
- [ ] Test all functionality
- [ ] Update documentation
- [ ] Release new GigVim version

## Success Metrics

1. **Primary Goal**: Remove flake input dependency
   - ✅ No `themery-nvim` in flake inputs
   - ✅ Uses `pkgs.vimPlugins.themery-nvim`
   - ✅ Builds succeed without external dependency

2. **Functionality Preserved**:
   - ✅ Theme switching works identically
   - ✅ All 77+ themes remain available  
   - ✅ Live preview functionality intact
   - ✅ Configuration options unchanged

3. **Build Performance**:
   - ✅ Faster builds (no GitHub fetch)
   - ✅ Uses nixpkgs binary cache
   - ✅ More reliable builds

## Expected Outcomes

### Immediate Benefits (Phase 1)
- **Faster builds**: No more GitHub fetching
- **Better reliability**: Uses nixpkgs infrastructure
- **Wider availability**: All Nix users can access
- **Reduced complexity**: Simpler flake.nix

### Long-term Benefits (Phase 2)
- **Better UX**: Type-safe configuration if nvf module created
- **Documentation**: Auto-generated option docs
- **Integration**: Works with other nvf theme modules

## Next Steps

1. **Start immediately** with nixpkgs submission
2. **File this documentation** in the repository for reference
3. **Create tracking issue** to monitor progress
4. **Prepare GigVim changes** while waiting for nixpkgs merge
5. **Consider nvf module** as future enhancement

This strategy balances immediate practical benefits (removing flake dependency) with potential future enhancements (better UX through nvf module), while minimizing risk and maintenance burden.