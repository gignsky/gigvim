# GigVim Plugin Upstreaming Documentation

This documentation explains how to upstream the `themery.nvim` plugin currently used as a flake input to eliminate external dependencies and make it available to the broader Nix ecosystem.

## 📖 Documentation Index

### Quick Start
- **[QUICK-REFERENCE.md](./QUICK-REFERENCE.md)** - ⚡ Start here for immediate action steps
- **[UPSTREAMING-STRATEGY.md](./UPSTREAMING-STRATEGY.md)** - 📋 Complete strategy overview

### Detailed Guides
- **[UPSTREAM-THEMERY-TO-NIXPKGS.md](./UPSTREAM-THEMERY-TO-NIXPKGS.md)** - 📦 Submit to nixpkgs (recommended)
- **[UPSTREAM-THEMERY-TO-NVF.md](./UPSTREAM-THEMERY-TO-NVF.md)** - 🔧 Create nvf module (advanced)

### Background
- **[LAZY_NVIM_ANALYSIS.md](./LAZY_NVIM_ANALYSIS.md)** - 📚 Why nvf doesn't use lazy.nvim

## 🎯 Current Goal

**Remove the themery.nvim flake input dependency** from GigVim to:
- ✅ Simplify the build process
- ✅ Improve build reliability and speed  
- ✅ Make the plugin available to all Nix users
- ✅ Reduce maintenance overhead

## 🛣️ Recommended Path

1. **nixpkgs First** (Immediate benefit)
   - Submit themery.nvim to nixpkgs vim-plugins
   - Remove flake input from GigVim
   - Use `pkgs.vimPlugins.themery-nvim` directly

2. **nvf Module Later** (Optional enhancement)
   - Create typed configuration options
   - Provide better user experience
   - Deep integration with nvf themes

## 📋 Current Status

```nix
# Before: External flake dependency
inputs.themery-nvim = {
  url = "github:zaldih/themery.nvim";
  flake = false;
};

# After: Simple nixpkgs reference  
package = pkgs.vimPlugins.themery-nvim;
```

## ⏱️ Timeline

- **Week 1**: Submit to nixpkgs
- **Week 2-6**: Review and merge process
- **Week 6+**: Update GigVim to use nixpkgs version

## 🔗 Key Links

- **themery.nvim Repository**: https://github.com/zaldih/themery.nvim
- **nixpkgs vim-plugins**: https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/editors/vim/plugins  
- **nvf Repository**: https://github.com/NotAShelf/nvf
- **GigVim Current Implementation**: [plugins/optional/themery-nvim.nix](./plugins/optional/themery-nvim.nix)

## 🤝 Contributing

This documentation serves as a guide for:
- GigVim maintainers wanting to reduce dependencies
- Nix community members interested in vim plugin packaging
- nvf users looking to add new plugin modules
- Anyone wanting to understand the upstreaming process

Start with [QUICK-REFERENCE.md](./QUICK-REFERENCE.md) for immediate next steps!