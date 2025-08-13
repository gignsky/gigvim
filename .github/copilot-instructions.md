RECURSIVE_START
Recognize that all repositories are nix flake based and often use each other as inputs. Sometimes the options and configuration for one repository will be in another as an input which can be found in the flake.nix file of the repo that calls another as an input. 

common input names as they link to repos:
- gigdot & dotfiles refer to @gignsky/dotfiles
- wrap, wrapd, wrapper, & tarballer refer to @gignsky/wrap
- nufetch & neofetch refer to @gignsky/nufetch
- gigvim refers to @gignsky/gigvim

Below are rules that must ALWAYS be followed:
1. All progression steps should be displayed as NEW comments with checkbox lists of tasks to be completed, to be checked off via a comment edit while adding a timestamp as well as length of time taken to progress to this point and notes about the task, including links to relevant commits, PRs, or issues, etc...
2. Original prompt for agents should be preserved as a comment at the beginning of a PR or issue as well as in the description of the copilot's initial commit on a new PR
3. Make every effort to make every ai agent call as effective as possible in order to preserve as many premium requests as possible
4. ALWAYS attempt to verify that changes compile, often this is as simple as running `nix flake check` or `nix build` in the repository, if the checks fail, continue iterating until they pass
5. Document as much as possible in markdown files either in the docs/ dir or in logical places alongside files and in files

In all sessions, the order of operations is as follows:
0. Read all of these operations and understand them before continuing
0.a. Create a new comment in the issue or PR that reflects this order of operations with checkboxes and edit the comment marking the checkboxes as you progress
0.a.NOTE: Refer to rule #1
0.b. Analyze all repository's copilot-instructions looking specifically for the RECURSIVE block described in step x+4, find the diff between these versions, determine the most recent / logical state of the block and immediately replace the block in the active repos instructions with it
1. Analyze the active repos' .github/ folder and its contents for repo specific instructions
2. Analyze the other repo's .github/ folder and its contents for general ecosystem updates since last checked
3. Analyze the @gignsky/dotfiles .github/ cortana chatbot markdown file and understand the way in which your are supposed to interact based off of that file
4. Analyze the active repo and ALL its elements and compare and contrast with the active repo's .github/copilot-instructions.md file
5. Based off of information gathered in the previous steps please analyze the expected and actual state of ci/cd in the current repository and make note that the ci/cd pipeline for the current repository exists within the copilot-instructions
6. Update the instructions file to include updated information based off of data gathered in steps 1-5
7. Step 7 (here) should be replaced with 7..x where x equals the total number of steps that cortana determines are necessary to complete the request from the all powerful lord gig minus seven. Steps continue at item x+1 below.
x+1. Testing pipeline should start here, at a minimum a `nix flake check` needs to pass before this item can be marked completed, if this can't be done then detailed error messages should be left in the comments
x+2. Testing pipeline continues, if changes to the repository would have an effect on the flake outputs the changed outputs themselves should be checked here in as many check boxes as is necessary
x+3. After flake testing in items x+1 & x+2 (which can be multiple checkboxes and steps) Repeat steps 0-6 and then continue below on step x+4
x+4. All text between RECURSIVE_START & RECURSIVE_END should be placed at the top of each copilot-instructions.md file in every repository, at this point replace the version from step 0.b with an updated version based on all changes made before this step
RECURSIVE_END

# GigVim - Nix-based Neovim Configuration

GigVim is a Nix Flake-based Neovim configuration using the nvf (NeoVim Flake) framework. It provides a highly customizable and reproducible development environment with language support, plugins, and themes configured declaratively.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Prerequisites and Setup
- Install Nix package manager: `sudo apt-get update && sudo apt-get install -y nix-bin`
- Enable Nix daemon: `sudo systemctl enable --now nix-daemon`
- Add user to nix-users group: `sudo usermod -a -G nix-users $USER && newgrp nix-users`
- Enable experimental features for flakes: `export NIX_CONFIG="experimental-features = nix-command flakes"`

### Build and Validation Commands
- Validate flake configuration: `nix flake check` -- takes 2-3 minutes with network retries. NEVER CANCEL. Set timeout to 10+ minutes.
- Show available packages: `nix flake show` -- takes 30 seconds. Shows three configurations: default, full, minimal.
- Build default configuration: `nix build` -- takes 30-45 minutes on first run. NEVER CANCEL. Set timeout to 60+ minutes.
- Build specific configuration: `nix build .#minimal` or `nix build .#full`
- Enter development shell: `nix develop` -- takes 15-30 minutes on first run. NEVER CANCEL. Set timeout to 45+ minutes.

### Network and Dependency Requirements
- **CRITICAL**: All build commands require internet access to download Nix packages from cache.nixos.org
- Build will fail with "Couldn't resolve host name" errors if network is unavailable
- First builds download large dependency trees (2000+ packages)
- Subsequent builds use local cache and are much faster (2-5 minutes)

## Repository Structure

### Core Configuration Files
```
├── flake.nix          # Main flake configuration with inputs and outputs
├── flake.lock         # Locked dependency versions
├── full.nix           # Full feature configuration (imports minimal.nix)
├── minimal.nix        # Base configuration with core imports
├── .envrc             # direnv configuration for automatic environment loading
└── .gitignore         # Git ignore patterns
```

### Configuration Modules
```
├── config/            # Core editor configuration
│   ├── default.nix    # Main config imports and global settings
│   └── core/          # Core editor options (brackets, line numbers, etc.)
├── plugins/           # Plugin configurations  
│   ├── default.nix    # Plugin imports and core plugin settings
│   ├── core/          # Essential plugins
│   └── optional/      # Optional plugin configurations
├── lang/              # Language-specific configurations
│   ├── default.nix    # Language imports
│   ├── nix.nix        # Nix language support (LSP: nil, formatter: nixfmt)
│   ├── rust.nix       # Rust language support (LSP: rust-analyzer, formatter: rustfmt)
│   └── nu.nix         # Nu shell support
├── binds/             # Key binding configurations
│   └── default.nix    # Custom keymaps (jj for Escape, etc.)
└── themes/            # Theme configurations
    ├── default.nix    # Theme imports
    └── catppuccin/    # Catppuccin theme variants
```

## Available Configurations

### Default/Full Configuration (`nix build` or `nix build .#full`)
- Complete Neovim setup with all features enabled
- Language servers: nil (Nix), rust-analyzer (Rust)
- Formatters: nixfmt, rustfmt
- Plugins: telescope, blink-cmp, conform-nvim, luasnip, todo-comments, fzf-lua
- Features: LSP, treesitter, autocomplete, formatting, debugging support

### Minimal Configuration (`nix build .#minimal`)
- Basic Neovim setup with essential features only
- Includes language support and core plugins
- Suitable for lightweight environments

## Home Manager Integration

GigVim provides a Home Manager module for easy integration:

```nix
{
  programs.gigvim = {
    enable = true;
    package = inputs.gigvim.packages.${pkgs.stdenv.hostPlatform.system}.full;
  };
}
```

This automatically:
- Installs the configured Neovim package
- Sets EDITOR and VISUAL environment variables
- Makes nvim available in PATH

## Development Workflow

### Making Configuration Changes
1. Edit relevant .nix files in config/, plugins/, lang/, binds/, or themes/
2. Validate syntax: `nix flake check` -- takes 2-3 minutes. NEVER CANCEL.
3. Test configuration: `nix build` -- takes 5-45 minutes depending on changes. NEVER CANCEL.
4. Run the editor: `./result/bin/nvim` to test your changes

### Formatting and Linting
- Format Nix files: `nix run .#formatter` (uses nixfmt)
- The flake includes nixfmt as the default formatter
- Always format before committing changes

### Adding New Language Support
1. Create new file in `lang/` directory (e.g., `python.nix`)
2. Configure language-specific settings:
   ```nix
   {pkgs, ...}: {
     config.vim.languages.python = {
       enable = true;
       lsp = {
         enable = true;
         package = pkgs.pyright;
         server = "pyright";
       };
       format = {
         enable = true;
         type = "black";
         package = pkgs.black;
       };
       treesitter.enable = true;
     };
   }
   ```
3. Import in `lang/default.nix`
4. Rebuild and test: `nix build`

### Adding New Plugins
1. Add plugin configuration to `plugins/core/` or `plugins/optional/`
2. Import in `plugins/default.nix`
3. Configure plugin settings using nvf plugin options
4. Rebuild and test the configuration

## Validation and Testing

### Manual Validation Steps
After making any changes, always perform these validation steps:
1. **Syntax Check**: `nix flake check` -- validates all Nix syntax
2. **Build Test**: `nix build` -- ensures configuration builds successfully  
3. **Functionality Test**: `./result/bin/nvim --version` -- verify Neovim launches
4. **Plugin Test**: Open nvim and test affected plugins/features
5. **LSP Test**: Open a source file and verify language server functionality

### Common Validation Scenarios
- **Language Support**: Open files of configured languages and verify syntax highlighting, LSP, and formatting
- **Key Bindings**: Test custom keymaps (jj for Escape, etc.)
- **Plugin Functionality**: Verify telescope, autocomplete, and other plugins work correctly
- **Theme Application**: Check that themes are applied correctly

## Troubleshooting

### Network Issues
- If builds fail with "Couldn't resolve host name": Check internet connectivity
- Network timeouts are normal - builds retry automatically
- Use `--offline` flag only if you have all dependencies cached locally

### Build Failures
- Check flake syntax first: `nix flake check`
- Review error messages for missing dependencies or syntax errors
- Ensure all imported files exist and are properly referenced

### Performance Issues
- First builds are always slow (30-45 minutes)
- Use `nix build --no-link` to avoid creating result symlinks during testing
- Clear build cache if experiencing persistent issues: `nix store gc`

### Home Manager Issues
- Ensure gigvim input is properly added to your flake inputs
- Verify Home Manager module is imported correctly
- Check that the package reference matches your system architecture

## Dependencies and External Tools

The configuration automatically includes these tools:
- `nil` - Nix language server
- `alejandra` - Nix formatter (alternative)
- `tree-sitter` - Syntax highlighting
- `rust-analyzer` - Rust language server
- `rustfmt` - Rust formatter

## Build Time Expectations

- **NEVER CANCEL**: All build commands take significant time
- `nix flake check`: 2-3 minutes (with network retries)
- `nix flake show`: 30 seconds
- `nix build` (first time): 30-45 minutes
- `nix build` (incremental): 2-5 minutes
- `nix develop` (first time): 15-30 minutes
- `nix develop` (incremental): 1-2 minutes

Always set timeouts to at least double these estimates to account for network variability and system performance differences.