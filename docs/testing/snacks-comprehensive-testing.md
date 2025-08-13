# Comprehensive Snacks.nvim Testing Guide

This guide provides detailed testing instructions for all snacks.nvim plugins integrated into GigVim.

## Core Functionality Tests

### 1. Dashboard (`snacks.dashboard`)

**Test Steps:**
1. Start Neovim without opening a file: `nvim`
2. Verify GIGVIM ASCII header appears
3. Test shortcuts:
   - Press `f` → Should open file picker
   - Press `n` → Should create new file
   - Press `g` → Should open grep search
   - Press `r` → Should show recent files
   - Press `c` → Should open config directory
   - Press `q` → Should quit

**Expected Behavior:** Clean dashboard with functional shortcuts

### 2. Notifications (`snacks.notifier`)

**Test Steps:**
```vim
:lua require('snacks').notifier.show("Test notification")
:lua require('snacks').notifier.show("Error test", "error")
:lua require('snacks').notifier.show("Warning test", "warn")
```

**Expected Behavior:** Styled notifications appear in top-right corner

### 3. File Explorer (`snacks.explorer`)

**Test Steps:**
1. Press `<leader>e` to toggle explorer
2. Navigate directories using arrow keys
3. Press Enter to open files
4. Press `<leader>e` again to close

**Expected Behavior:** File tree replaces netrw functionality

### 4. Picker System (`snacks.picker`)

**Test Each Picker:**
- `<leader>ff` - File finder
- `<leader>fb` - Buffer list  
- `<leader>fg` - Live grep
- `<leader>fr` - Recent files
- `<leader>fs` - Symbols search
- `<leader>gf` - Git files

**Expected Behavior:** Fast, responsive pickers with preview

### 5. Git Integration

**Git Operations:**
- `<leader>gg` - Lazygit (requires lazygit installed)
- `<leader>gs` - Git blame line
- `<leader>gf` - Git files picker

**Git-dev Integration:**
- `<leader>gdo` - Open remote repository (snacks input dialog)
- `<leader>gdr` - Browse recent repositories  
- `<leader>gdc` - Clean current repository
- `<leader>gdC` - Clean all cached repositories
- `<leader>gdb` - Close all buffers for current repository
- `<leader>gdu` - Toggle git-dev output window
- `<leader>gr` - Browse recent repositories

**Expected Behavior:** Seamless git workflow integration

## Visual Enhancement Tests

### 6. Indent Guides (`snacks.indent`)

**Test Steps:**
1. Open a code file with nested blocks (e.g., Nix, Python, JavaScript)
2. Move cursor through different scopes
3. Verify indent lines appear
4. Check chunk highlighting on scope selection

**Expected Behavior:** 
- Vertical guides show indentation
- Current scope highlighted with chunks
- Smooth animations when moving between scopes

### 7. Dim Plugin (`snacks.dim`)

**Test Steps:**
1. Open a file with functions/classes
2. Place cursor inside a function
3. Observe dimming of code outside current scope
4. Move to different functions

**Expected Behavior:** Code outside current scope appears dimmed

**Troubleshooting:** If not working, check treesitter support:
```vim
:TSInstallInfo
:lua require('snacks').dim.enable()
```

### 8. Scope Highlighting (`snacks.scope`)

**Test Steps:**
1. Navigate through nested code blocks
2. Verify current scope is visually distinct
3. Test with different file types

**Expected Behavior:** Clear visual indication of current scope

## Animation Tests

### 9. Smooth Scrolling (`snacks.scroll`)

**Test Steps:**
1. Open a long file
2. Use `Ctrl+D`, `Ctrl+U`, `PageDown`, `PageUp`
3. Observe smooth scrolling animations

**Expected Behavior:** Smooth, eased scrolling motion

### 10. Window Animations (`snacks.animate`)

**Test Steps:**
1. Split windows: `:split`, `:vsplit`
2. Resize windows with mouse or keybindings
3. Move between windows

**Expected Behavior:** Smooth window resize and movement animations

## Utility Plugin Tests

### 11. Buffer Management (`snacks.bufdelete`)

**Test Buffer Operations:**
- `<leader>bd` - Delete current buffer
- `<leader>ba` - Delete all buffers
- `<leader>bo` - Delete other buffers

**Expected Behavior:** Intelligent buffer management with notifications

### 12. Terminal (`snacks.terminal`)

**Test Steps:**
1. Press `<leader>tf` to open floating terminal
2. Run commands in terminal
3. Press `<leader>tf` again to toggle

**Expected Behavior:** Floating terminal overlay

### 13. Status Column (`snacks.statuscolumn`)

**Test Steps:**
1. Open files with line numbers
2. Verify custom status column appears
3. Test with git changes (if in git repo)

**Expected Behavior:** Enhanced status column with git indicators

### 14. Word Highlighting (`snacks.words`)

**Test Steps:**
1. Place cursor on a word
2. Wait for highlighting to activate
3. Move to different words

**Expected Behavior:** Automatic highlighting of word under cursor

## Advanced Feature Tests

### 15. Input System (`snacks.input`)

**Test Steps:**
1. Use `<leader>go` (git-dev with snacks input)
2. Test autocomplete in input field
3. Test escape to cancel

**Expected Behavior:** Styled input dialogs with proper key handling

### 16. Layout Management (`snacks.layout`)

**Test Steps:**
1. Create complex window layouts
2. Save and restore layouts
3. Test predefined layouts

**Expected Behavior:** Sophisticated window management

### 17. Performance Profiler (`snacks.profiler`)

**Test Steps:**
```vim
:lua require('snacks').profiler.start()
" Perform some operations
:lua require('snacks').profiler.show()
```

**Expected Behavior:** Performance profiling data displayed

### 18. Debug Tools (`snacks.debug`)

**Test Steps:**
```vim
:lua require('snacks').debug.inspect({test = "data"})
:lua require('snacks').debug.log("Debug message")
```

**Expected Behavior:** Debug information displayed properly

## Performance Tests

### 19. Large File Handling (`snacks.bigfile`)

**Test Steps:**
1. Open a large file (>100MB if available)
2. Verify performance optimizations kick in
3. Check that features are disabled appropriately

**Expected Behavior:** Maintained performance with large files

### 20. Quick File Loading (`snacks.quickfile`)

**Test Steps:**
1. Open multiple files rapidly
2. Test file switching performance

**Expected Behavior:** Fast file loading and switching

## Health Check Verification

### 21. Complete Health Check

**Run Full Diagnostic:**
```vim
:checkhealth snacks
```

**Expected Output:** All plugins should show "OK setup {enabled}"

**Troubleshooting:** See `docs/troubleshooting/snacks-health-check.md`

## Theme Integration Tests

### 22. Theme Compatibility

**Test Steps:**
1. Switch themes using `<leader>th`
2. Verify snacks elements adapt to new theme
3. Test with different Catppuccin variants

**Expected Behavior:** Consistent styling across all themes

## Integration Tests

### 23. Cross-Plugin Functionality

**Test Combinations:**
1. Use picker to find files, then use explorer to navigate
2. Open terminal, then use git commands
3. Use notifications with different snacks operations

**Expected Behavior:** Seamless integration between all components

## Error Handling Tests

### 24. Error Conditions

**Test Error Cases:**
1. Try to open non-existent files via picker
2. Use git operations outside git repository
3. Test with corrupted/binary files

**Expected Behavior:** Graceful error handling with informative messages

## Performance Benchmarks

### 25. Startup Time

**Measure Impact:**
```bash
nvim --startuptime startup.log +quit
grep snacks startup.log
```

**Expected:** Minimal impact on startup time

## Keybinding Tests

### 26. All Keybinding Verification

**Test Each Binding:**
- Verify no conflicts exist
- Test in different modes (normal, insert)
- Verify WhichKey descriptions appear

**Expected Behavior:** All keybindings work without conflicts

## Final Integration Test

### 27. Complete Workflow Test

**Real-world Scenario:**
1. Start Neovim (dashboard appears)
2. Find and open a project file
3. Use git integration to check changes
4. Open terminal to run commands
5. Use multiple windows and splits
6. Switch themes
7. Use all major snacks features

**Expected Behavior:** Smooth, integrated development experience

## Reporting Issues

When reporting issues, include:
1. Steps to reproduce
2. Expected vs actual behavior
3. Output of `:checkhealth snacks`
4. Output of `:messages`
5. Neovim version and OS
6. GigVim configuration variant (minimal/full)