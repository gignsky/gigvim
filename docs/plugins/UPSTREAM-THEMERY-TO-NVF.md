# Creating a Built-in nvf Module for themery.nvim

This document outlines the process to create a native nvf module for `themery.nvim`, which would provide first-class integration and eliminate the need for external plugin configuration.

## Overview

Currently, GigVim uses `themery.nvim` as an external plugin via `extraPlugins`. By creating a built-in nvf module, users would be able to configure it like other nvf plugins:

```nix
# Current approach (external plugin)
config.vim.extraPlugins.themery = {
  package = themery-from-source;
  setup = ''require('themery').setup({...})'';
};

# After creating nvf module
config.vim.ui.themery = {
  enable = true;
  themes = [ "catppuccin" "tokyonight" "gruvbox" ];
  livePreview = true;
  defaultTheme = "catppuccin-mocha";
};
```

## Why Create an nvf Module?

### Benefits

1. **Type Safety**: Nix type checking for all options
2. **Documentation**: Automatic option documentation generation
3. **Integration**: Works seamlessly with nvf's configuration system
4. **User Experience**: Simpler configuration for users
5. **Validation**: Input validation and helpful error messages
6. **Discoverability**: Shows up in nvf options documentation

### When to Choose This Over nixpkgs

Choose **nvf module** when:
- Plugin needs deep nvf integration
- Want type-safe configuration options
- Plugin configuration is complex
- Want to provide nvf-specific defaults

Choose **nixpkgs** when:
- Plugin is simple and self-contained
- Want maximum compatibility
- Plugin doesn't need special nvf features

## Step-by-Step Process

### 1. Understand nvf Module Structure

nvf modules follow this pattern:
```
modules/plugins/ui/themery/
├── default.nix     # Module exports
├── themery.nix     # Options definition
└── config.nix      # Implementation
```

### 2. Analyze Plugin Requirements

**themery.nvim** setup structure:
```lua
require('themery').setup({
  themes = { "theme1", "theme2", ... },
  livePreview = true,
  themeConfigFile = "~/.config/nvim/lua/settings/theme.lua",
  defaultTheme = "theme1",
})
```

### 3. Choose Module Category

Based on functionality, themery belongs in:
- **`modules/plugins/ui/`** - UI enhancement (theme switching)

### 4. Create Module Structure

Create the directory:
```bash
mkdir -p modules/plugins/ui/themery
```

### 5. Define Module Options

```nix
# modules/plugins/ui/themery/themery.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) bool str listOf enum nullOr;
  inherit (lib.nvim.types) mkPluginSetupOption;
in {
  options.vim.ui.themery = {
    enable = mkEnableOption "themery.nvim theme switcher";

    package = mkOption {
      type = lib.types.package;
      default = pkgs.vimPlugins.themery-nvim or (pkgs.vimUtils.buildVimPlugin {
        name = "themery-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "zaldih";
          repo = "themery.nvim";
          rev = "main";
          sha256 = lib.fakeSha256;  # Would need real hash
        };
      });
      description = "The themery.nvim package to use";
    };

    themes = mkOption {
      type = listOf str;
      default = [
        # Built-in vim themes
        "default" "blue" "darkblue" "delek" "desert" 
        "elflord" "evening" "industry" "koehler"
        "morning" "murphy" "pablo" "peachpuff"
        "ron" "shine" "slate" "torte" "zellner"
        # Popular plugin themes (when available)
        "catppuccin" "tokyonight" "gruvbox" "nord"
        "onedark" "dracula" "material" "nightfox"
      ];
      description = "List of theme names to include in the picker";
      example = [ "catppuccin-mocha" "tokyonight-night" "gruvbox-dark" ];
    };

    livePreview = mkOption {
      type = bool;
      default = true;
      description = "Enable live preview when browsing themes";
    };

    defaultTheme = mkOption {
      type = nullOr str;
      default = null;
      description = "Default theme to apply on startup";
      example = "catppuccin-mocha";
    };

    themeConfigFile = mkOption {
      type = nullOr str;
      default = null;
      description = "Path to theme configuration file";
      example = "~/.config/nvim/lua/settings/theme.lua";
    };

    keymaps = {
      toggle = mkOption {
        type = nullOr str;
        default = "<leader>tt";
        description = "Keymap to toggle theme picker";
      };
    };

    setupOpts = mkPluginSetupOption "themery" {
      # Additional setup options not covered above
    };
  };
}
```

### 6. Implement Module Configuration

```nix
# modules/plugins/ui/themery/config.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.nvim.dag) entryAnywhere;
  inherit (lib.nvim.lua) toLuaObject;
  
  cfg = config.vim.ui.themery;

  # Build final setup options
  setupOpts = lib.recursiveUpdate {
    themes = cfg.themes;
    livePreview = cfg.livePreview;
    defaultTheme = cfg.defaultTheme;
    themeConfigFile = cfg.themeConfigFile;
  } cfg.setupOpts;
in {
  config = mkIf cfg.enable (mkMerge [
    # Plugin configuration
    {
      vim.startPlugins = [ cfg.package ];

      vim.luaConfigRC.themery = entryAnywhere ''
        require('themery').setup(${toLuaObject setupOpts})
      '';
    }

    # Keymaps
    (mkIf (cfg.keymaps.toggle != null) {
      vim.maps.normal.${cfg.keymaps.toggle} = {
        action = "<cmd>Themery<CR>";
        desc = "Open theme picker";
      };
    })

    # Auto-apply default theme
    (mkIf (cfg.defaultTheme != null) {
      vim.luaConfigRC.themery-default = entryAnywhere ''
        -- Apply default theme on startup
        vim.schedule(function()
          vim.cmd.colorscheme("${cfg.defaultTheme}")
        end)
      '';
    })
  ]);
}
```

### 7. Create Module Entry Point

```nix
# modules/plugins/ui/themery/default.nix
{
  imports = [
    ./themery.nix
    ./config.nix
  ];
}
```

### 8. Register Module in nvf

Add to the main plugins module:

```nix
# modules/plugins/default.nix
{
  imports = [
    # ... existing imports
    ./ui/themery
    # ... rest of imports
  ];
}
```

### 9. Add Dependencies (if needed)

If themery works better with certain themes, add them as optional dependencies:

```nix
# In config.nix
{
  config = mkIf cfg.enable {
    # Suggest popular themes if they're not already configured
    vim.startPlugins = [ cfg.package ] 
      ++ lib.optional config.vim.theme.catppuccin.enable pkgs.vimPlugins.catppuccin-nvim
      ++ lib.optional config.vim.theme.tokyonight.enable pkgs.vimPlugins.tokyonight-nvim;
  };
}
```

### 10. Write Tests

```nix
# tests/plugins/ui/themery.nix
{
  empty = {
    vim.ui.themery.enable = true;
  };

  with-custom-themes = {
    vim.ui.themery = {
      enable = true;
      themes = [ "catppuccin-mocha" "tokyonight-night" ];
      defaultTheme = "catppuccin-mocha";
      livePreview = false;
    };
  };

  with-custom-keymaps = {
    vim.ui.themery = {
      enable = true;
      keymaps.toggle = "<leader>th";
    };
  };
}
```

### 11. Update Documentation

The module will automatically generate documentation, but you can enhance it:

```nix
# In themery.nix options
description = lib.mdDoc ''
  Enable themery.nvim, a theme switcher plugin with live preview.
  
  Themery allows you to quickly switch between different colorschemes
  and see the changes in real-time before applying them.
  
  Example configuration:
  ```nix
  vim.ui.themery = {
    enable = true;
    themes = [ "catppuccin-mocha" "tokyonight-night" "gruvbox-dark" ];
    defaultTheme = "catppuccin-mocha";
    livePreview = true;
  };
  ```
'';
```

## Integration with nvf Development

### 1. Fork nvf Repository

```bash
git clone https://github.com/NotAShelf/nvf
cd nvf
git checkout -b add-themery-module
```

### 2. Implement Module

Follow the steps above to create the module files.

### 3. Test the Module

```bash
# Build with the new module
nix build --show-trace

# Test with a configuration
nix build --show-trace .#neovimConfiguration.x86_64-linux --arg modules '[
  {
    vim.ui.themery = {
      enable = true;
      themes = [ "catppuccin" "tokyonight" ];
    };
  }
]'
```

### 4. Create Pull Request

```markdown
# feat: add themery.nvim module

## Description
Add built-in support for themery.nvim, a theme switcher plugin with live preview.

## Features
- Type-safe configuration options
- Integration with nvf's plugin system
- Automatic keymap setup
- Support for default theme selection
- Live preview toggle

## Usage
```nix
vim.ui.themery = {
  enable = true;
  themes = [ "catppuccin-mocha" "tokyonight-night" ];
  defaultTheme = "catppuccin-mocha";
  livePreview = true;
  keymaps.toggle = "<leader>tt";
};
```

## Testing
- [x] Module builds without errors
- [x] Plugin loads correctly
- [x] Configuration options work as expected
- [x] Tests pass

## Related
- Plugin: https://github.com/zaldih/themery.nvim
- Closes: #XXX (if there's an issue requesting this)
```

## Advanced Features

### Theme Detection Integration

```nix
# Auto-detect available themes based on enabled nvf modules
themes = mkOption {
  type = listOf str;
  default = 
    # Built-in themes
    ["default" "blue" "desert" /* ... */] 
    # Dynamically add themes based on config
    ++ lib.optional config.vim.theme.catppuccin.enable "catppuccin"
    ++ lib.optional config.vim.theme.tokyonight.enable "tokyonight"
    ++ lib.optional config.vim.theme.gruvbox.enable "gruvbox";
};
```

### Lazy Loading Support

```nix
# For lazy loading with lz.n
vim.lazy.plugins.themery = mkIf cfg.lazy {
  package = cfg.package;
  setupModule = "themery";
  inherit (cfg) setupOpts;
  cmd = [ "Themery" ];
  keys = lib.optional (cfg.keymaps.toggle != null) {
    key = cfg.keymaps.toggle;
    action = "<cmd>Themery<CR>";
    desc = "Open theme picker";
  };
};
```

## Benefits of the nvf Module Approach

1. **Better User Experience**: Simple, typed configuration
2. **Integration**: Works with nvf's existing theme modules  
3. **Maintainability**: Centralized in nvf codebase
4. **Documentation**: Auto-generated option docs
5. **Validation**: Type checking catches errors early
6. **Evolution**: Can evolve with nvf's features

## Comparison with External Plugin

| Aspect | External Plugin | nvf Module |
|--------|----------------|------------|
| Configuration | Manual Lua setup | Typed Nix options |
| Documentation | Manual | Auto-generated |
| Validation | Runtime errors | Build-time checks |
| Integration | Basic | Deep nvf integration |
| Maintenance | User responsibility | nvf team |
| Discoverability | Low | High (in docs) |

## Conclusion

Creating an nvf module for themery.nvim provides the best user experience and integration with the nvf ecosystem. It requires more initial work but pays off with better maintainability and user experience.

Choose this approach if you want to provide first-class theme switching functionality in nvf.