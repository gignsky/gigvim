# Overlays Documentation

## Namespaced Overlay Pattern (Option 2)

GigVim uses a namespaced overlay pattern to provide access to packages from different nixpkgs branches without overriding top-level package attributes.

### Why This Pattern?

This pattern allows us to:
- Access packages from nixpkgs master branch when needed (e.g., for the latest Themery plugin)
- Avoid global overrides that could affect all packages unexpectedly
- Maintain reproducibility while selectively using newer packages
- Keep the base system stable while accessing cutting-edge packages

### How It Works

The overlay is defined in `overlays.nix`:

```nix
{
  master-packages = final: prev: {
    master = import inputs.nixpkgs-master {
      inherit (prev) system;
      config = prev.config or {};
      overlays = [ ];
    };
  };
}
```

Key design decisions:
- **Namespaced access**: Packages are accessed via `pkgs.master.*` instead of overriding `pkgs.*`
- **No recursive overlays**: `overlays = [ ]` prevents infinite recursion
- **Inherits system and config**: Maintains consistency with the base pkgs configuration
- **No top-level overrides**: Only adds the `master` attribute, doesn't modify existing packages

### How to Use pkgs.master

In module files, access master packages via the namespaced attribute:

```nix
{ pkgs, ... }:
{
  config.vim.extraPlugins = {
    some-plugin = {
      # Use package from master branch
      package = pkgs.master.vimPlugins.some-plugin;
      
      # While other packages use the base stable branch
      other-package = pkgs.vimPlugins.other-plugin;
    };
  };
}
```

### Current Usage

Currently, only Themery.nvim uses packages from `pkgs.master`:

- **File**: `plugins/optional/themery-nvim.nix`
- **Usage**: `pkgs.master.vimPlugins.themery-nvim`
- **Reason**: Themery is a newer plugin that may not be in the stable nixpkgs branch

### Benefits Over Global Overrides

1. **Explicit intent**: It's clear which packages come from master vs stable
2. **Reduced conflicts**: No accidental override of stable packages
3. **Easy rollback**: Can switch individual packages back to stable easily
4. **Better debugging**: Package source is obvious from the code

### How to Revert

To revert a package from master back to stable:

```nix
# Before (using master)
package = pkgs.master.vimPlugins.some-plugin;

# After (using stable)
package = pkgs.vimPlugins.some-plugin;
```

To remove the overlay entirely:

1. Remove `nixpkgs-master` input from `flake.nix`
2. Remove `overlays.master-packages` from overlay application in `flake.nix`
3. Update any modules using `pkgs.master.*` to use `pkgs.*`

### Implementation Details

The overlay is applied globally in `flake.nix`:

```nix
perSystem = { system, ... }:
let
  overlays = import ./overlays.nix { inherit inputs; };
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ overlays.master-packages ];
    config.allowUnfree = true;
  };
```

This makes `pkgs.master` available to all modules that receive the `pkgs` parameter.