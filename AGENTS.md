# GigVim - Agent Guidelines

GigVim is a Nix Flake-based Neovim configuration using the [nvf (NeoVim Flake)](https://github.com/NotAShelf/nvf) framework. This document provides coding standards and workflows for agents working in this repository.

**NOTE**: Always reference `.github/copilot-instructions.md` first for detailed build/validation instructions and fallback to search only when needed.

## Build & Test Commands

### Core Build Commands
- **Validate flake**: `nix flake check` (2-3 min, NEVER CANCEL, set 10+ min timeout)
- **Show configs**: `nix flake show` (30 sec, shows: default, full, minimal)
- **Build default**: `nix build` (30-45 min first run, 2-5 min incremental, NEVER CANCEL)
- **Build minimal**: `nix build .#minimal`
- **Build full**: `nix build .#full` (alias: `.#gigvim`)
- **Dev shell**: `nix develop` (15-30 min first run, 1-2 min incremental)
- **Test editor**: `./result/bin/nvim --version` (after build)

### Formatting & Linting
- **Format all Nix**: `nix run .#formatter` (uses nixfmt-rfc-style)
- **Format specific file**: `nixfmt <file.nix>`
- **ALWAYS format before committing**

### Testing Single Components
- **Test config module**: Edit, then `nix build` and verify with `./result/bin/nvim`
- **Test language support**: `./result/bin/nvim test.rs` (or .nix, .py, etc.)
- **Test plugin**: Open nvim and exercise plugin features manually
- **No automated test suite exists** - validation is manual via build + runtime testing

### Network & Performance Notes
- **CRITICAL**: All builds require internet for cache.nixos.org
- First builds download 2000+ packages (30-45 min)
- Subsequent builds are cached (2-5 min)
- NEVER use `--offline` unless cache is complete
- Set generous timeouts (60+ min for first builds)

## Repository Structure

```
├── flake.nix           # Main flake (inputs, outputs, packages)
├── flake.lock          # Locked dependencies (commit after updates)
├── full.nix            # Full config (imports minimal.nix + extras)
├── minimal.nix         # Base config (core imports)
├── overlays.nix        # Package overlays (master/local/tectonic)
├── .envrc              # direnv config (use flake)
├── config/             # Core editor configuration
│   ├── default.nix     # Global settings (clipboard, leader keys, packages)
│   ├── core/           # Essential configs (options, git, line, theme, etc.)
│   └── optional/       # Optional configs (notes, diagnostics)
├── plugins/            # Plugin configurations
│   ├── default.nix     # Core plugins (telescope, conform, fzf-lua)
│   ├── core/           # Essential plugins (blink-cmp)
│   ├── optional/       # Optional plugins (mini, commasemi)
│   ├── resources/      # Plugin resources
│   └── templates/      # Plugin templates
├── lang/               # Language-specific configs
│   ├── default.nix     # LSP/DAP/treesitter global settings
│   └── *.nix           # Per-language configs (nix, rust, bash, etc.)
├── binds/              # Keybinding configurations
│   ├── default.nix     # Global keymaps (jj for Esc, <leader>w, etc.)
│   ├── module/         # Plugin-specific keybinds
│   └── optional/       # Optional keybinds (folding)
├── vim-modules/        # Custom plugin modules (git-dev, snacks, spectre)
└── themes/             # Theme configurations (catppuccin variants)
```

## Code Style Guidelines

### Nix Code Standards

#### File Structure
- **Always** use `{ pkgs, ... }:` or `{ inputs, pkgs, ... }:` attribute set pattern
- Place `imports = [ ... ];` first, then `config.*` blocks
- Use `let...in` for local bindings when needed
- Keep files focused: one language/plugin/module per file

#### Imports & Organization
```nix
# Good: Explicit imports
{
  imports = [
    ./core
    ./optional/feature.nix
  ];
  
  config.vim.option = value;
}

# Bad: Missing imports, disorganized
{ config.vim.option = value; }
```

#### Formatting & Spacing
- **Use nixfmt-rfc-style** (2-space indentation, enforced)
- Align `=` signs in attribute sets when beneficial
- Keep lines under 100 chars (soft limit, not enforced)
- Use trailing semicolons consistently
- Break long lists/sets across multiple lines

#### Naming Conventions
- **Files**: `kebab-case.nix` (e.g., `git-dev-nvim.nix`)
- **Attributes**: `camelCase` or `kebab-case` (follow nvf conventions)
- **Variables**: `camelCase` (e.g., `fullConfigModule`, `gitDev`)
- **Constants**: `SCREAMING_SNAKE_CASE` (rare in Nix)

#### Types & Documentation
```nix
# Good: Clear structure with comments
{ pkgs, ... }:
{
  # Rust language support with full LSP features
  config.vim.languages.rust = {
    enable = true;
    lsp.enable = true;
    format.enable = true;
  };
}
```

#### Configuration Patterns
```nix
# Language module pattern
{ pkgs, ... }:
{
  config.vim.languages.<lang> = {
    enable = true;
    lsp = {
      enable = true;
      package = pkgs.<lsp>;
      server = "<server-name>";
      opts = ''...'';  # Lua config
    };
    format = {
      enable = true;
      type = "<formatter>";
      package = pkgs.<formatter>;
    };
    treesitter.enable = true;
  };
}

# Plugin module pattern (vim-modules/)
{ inputs, pkgs, ... }:
let
  pluginModule = import ../plugins/optional/<plugin>.nix { inherit inputs pkgs; };
in
{
  imports = [
    pluginModule
    ../binds/module/<plugin>.nix
  ];
}
```

#### String Handling
- Use `"double quotes"` for strings
- Use `''multi-line strings''` for Lua code blocks
- Escape `${...}` in multi-line strings as `''${...}` when needed

#### Lists & Sets
```nix
# Good: Clean list formatting
imports = [
  ./file1.nix
  ./file2.nix
  ./file3.nix
];

# Good: Attribute set
config.vim.keymaps = [
  {
    key = "jj";
    mode = "i";
    silent = true;
    action = "<Esc>";
  }
];
```

### Error Handling

#### Common Errors
- **Syntax errors**: Caught by `nix flake check`
- **Build errors**: Caught by `nix build`
- **Runtime errors**: Caught by testing in nvim
- **No try/catch** - Nix fails fast on errors

#### Debugging Strategy
1. Run `nix flake check` for syntax validation
2. Run `nix build` to catch evaluation errors
3. Check `./result/bin/nvim` for runtime issues
4. Read error messages carefully (trace through imports)
5. Use `nix repl` for interactive debugging if needed

### Comments & Documentation
- Use `#` for single-line comments
- Document non-obvious configurations
- Reference upstream docs in comments (e.g., rust-analyzer links)
- Keep comments concise and relevant

## Workflow Guidelines

### Making Changes
1. Edit relevant `.nix` files in appropriate directories
2. Run `nix flake check` to validate syntax (2-3 min)
3. Run `nix build` to test configuration (5-45 min)
4. Test with `./result/bin/nvim` to verify functionality
5. Format with `nix run .#formatter` before committing

### Adding Language Support
1. Create `lang/<language>.nix` following existing patterns
2. Import in `lang/default.nix`
3. Configure LSP, formatter, treesitter, DAP as needed
4. Test with real files: `./result/bin/nvim test.<ext>`

### Adding Plugins
1. **Core plugins**: Add to `plugins/core/<plugin>.nix`
2. **Optional plugins**: Add to `plugins/optional/<plugin>.nix`
3. **Custom modules**: Add to `vim-modules/<plugin>Module.nix`
4. Import in appropriate `default.nix`
5. Add keybinds in `binds/` if needed

### Git Workflow
- **Branch naming**: `feature/<desc>`, `lang/<lang>`, `plugin/<name>`, `cleanup/<desc>`
- **Commit style**: Lowercase, imperative (see recent commits)
  - Examples: "added spectre", "updated git diff view options", "fixed up missing semi colon"
- **NEVER** commit `result/` symlinks (gitignored)
- **ALWAYS** commit `flake.lock` after input updates

### Commit Policy (per ~/.dotfiles/AGENTS.md)
All commits must include:
1. Descriptive title (lowercase, imperative)
2. `[ ] Reviewed by Lord G.`
3. File tree with +/- diff
4. Host info (repo/branch, hostname, NixOS gen, HM gen)
5. Agent signature
6. `---` (page break)
7. Additional context/details

### Testing Checklist
- [ ] Syntax: `nix flake check` passes
- [ ] Build: `nix build` succeeds
- [ ] Launch: `./result/bin/nvim --version` works
- [ ] LSP: Open file, verify completions/diagnostics
- [ ] Format: Code formatting works in editor
- [ ] Keybinds: Test custom keymaps (jj, <leader>w)
- [ ] Plugins: Verify affected plugins work

## Key Configuration Details

### Global Settings
- **Leader key**: `<Space>`
- **Clipboard**: System clipboard (`unnamedplus`)
- **Format on save**: Enabled via LSP
- **Indentation**: 2 spaces (expandtab)
- **Line numbers**: Enabled
- **Inlay hints**: Enabled

### Available Packages
- `minimal`: Core features, essential plugins
- `full` (default): All features, all plugins
- `gigvim`: Alias for `full`

### Home Manager Integration
```nix
programs.gigvim = {
  enable = true;
  package = inputs.gigvim.packages.${system}.full;
};
```

## References
- nvf docs: https://github.com/NotAShelf/nvf
- Nix manual: https://nixos.org/manual/nix/stable/
- Full build details: `.github/copilot-instructions.md`
