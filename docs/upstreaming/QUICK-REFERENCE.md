# Quick Reference: Removing themery.nvim Flake Dependency

This is a quick reference for the **immediate next steps** to upstream themery.nvim and remove the flake input dependency from GigVim.

## 🎯 Recommended Immediate Action: nixpkgs Upstream

**Goal**: Remove `themery-nvim` flake input by adding the plugin to nixpkgs

**Time**: 2-3 hours of work, 2-6 weeks for merge

**Risk**: Low (established process)

## 📋 Step-by-Step Checklist

### Phase 1: Submit to nixpkgs

- [ ] **1. Fork nixpkgs** (5 minutes)
  ```bash
  git clone https://github.com/NixOS/nixpkgs
  cd nixpkgs
  git checkout -b add-themery-nvim
  ```

- [ ] **2. Add to plugin list** (10 minutes)
  ```bash
  # Add this line to vim-plugin-names in alphabetical order:
  echo "https://github.com/zaldih/themery.nvim,," >> pkgs/applications/editors/vim/plugins/vim-plugin-names
  
  # Sort the file
  sort -o pkgs/applications/editors/vim/plugins/vim-plugin-names pkgs/applications/editors/vim/plugins/vim-plugin-names
  ```

- [ ] **3. Generate plugin** (15 minutes)  
  ```bash
  cd pkgs/applications/editors/vim/plugins
  ./utils/update.py
  ```

- [ ] **4. Test locally** (30 minutes)
  ```bash
  nix-build -A vimPlugins.themery-nvim
  ```

- [ ] **5. Submit PR** (30 minutes)
  ```bash
  git add vim-plugin-names generated.nix
  git commit -m "vimPlugins.themery-nvim: init"
  git push origin add-themery-nvim
  # Create PR on GitHub
  ```

### Phase 2: Wait for merge (2-6 weeks)

- [ ] **Monitor PR status** weekly
- [ ] **Respond to feedback** if requested
- [ ] **Confirm merge** to nixpkgs

### Phase 3: Update GigVim (30 minutes)

- [ ] **Remove flake input**
  ```nix
  # Delete this from flake.nix:
  themery-nvim = {
    url = "github:zaldih/themery.nvim";
    flake = false;
  };
  ```

- [ ] **Update plugin config**
  ```nix
  # In plugins/optional/themery-nvim.nix
  # Change from:
  package = themery-from-source;
  # To:
  package = pkgs.vimPlugins.themery-nvim;
  ```

- [ ] **Update full.nix**
  ```nix
  # Change from:
  { inputs, pkgs, ... }:
  # To:
  { pkgs, ... }:
  ```

- [ ] **Test everything works**
  ```bash
  nix flake check
  nix build .#default
  ./result/bin/nvim  # Test :Themery command
  ```

## 🔗 Links to Full Documentation

- **[UPSTREAM-THEMERY-TO-NIXPKGS.md](./UPSTREAM-THEMERY-TO-NIXPKGS.md)** - Complete nixpkgs submission guide
- **[UPSTREAM-THEMERY-TO-NVF.md](./UPSTREAM-THEMERY-TO-NVF.md)** - Alternative: Creating nvf module
- **[UPSTREAMING-STRATEGY.md](./UPSTREAMING-STRATEGY.md)** - Complete strategy and comparison

## ⚡ TL;DR Commands

```bash
# 1. Add to nixpkgs
git clone https://github.com/NixOS/nixpkgs
cd nixpkgs
git checkout -b add-themery-nvim
echo "https://github.com/zaldih/themery.nvim,," >> pkgs/applications/editors/vim/plugins/vim-plugin-names
sort -o pkgs/applications/editors/vim/plugins/vim-plugin-names pkgs/applications/editors/vim/plugins/vim-plugin-names
cd pkgs/applications/editors/vim/plugins && ./utils/update.py
nix-build -A vimPlugins.themery-nvim
git add vim-plugin-names generated.nix
git commit -m "vimPlugins.themery-nvim: init"
git push origin add-themery-nvim
# Create PR on GitHub

# 2. After merge, update GigVim
# Remove themery-nvim from flake.nix inputs
# Change package = themery-from-source to package = pkgs.vimPlugins.themery-nvim
# Remove inputs parameter from full.nix
# Test: nix build .#default
```

## 🎉 Expected Result

**Before:**
```nix
# Complex flake input setup
inputs.themery-nvim = { url = "github:zaldih/themery.nvim"; flake = false; };
package = pkgs.vimUtils.buildVimPlugin { src = inputs.themery-nvim; };
```

**After:**
```nix
# Simple nixpkgs reference
package = pkgs.vimPlugins.themery-nvim;
```

**Benefits:**
- ✅ Faster builds (no GitHub fetch)
- ✅ More reliable (nixpkgs infrastructure)  
- ✅ Available to all Nix users
- ✅ Simpler flake.nix