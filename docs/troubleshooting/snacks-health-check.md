# Snacks.nvim Health Check Troubleshooting

This guide helps resolve issues with snacks.nvim plugins not appearing in `:checkhealth snacks`.

## Common Issues and Solutions

### Plugin Not Appearing in Health Check

If a specific snacks plugin (like `snacks.dim` or `snacks.profiler`) doesn't appear in `:checkhealth snacks`:

1. **Check if snacks is loaded**:
   ```lua
   :lua print(vim.inspect(require('snacks').config))
   ```

2. **Verify plugin is enabled**:
   ```lua
   :lua print(require('snacks').config.dim.enabled)
   :lua print(require('snacks').config.profiler.enabled)
   ```

3. **Check for errors**:
   ```vim
   :messages
   ```

### Snacks.dim Not Working

If `snacks.dim` is enabled but not visible in health check:

1. **Test manual dimming**:
   ```lua
   :lua require('snacks').dim.enable()
   ```

2. **Check treesitter support**:
   ```vim
   :TSInstallInfo
   ```
   Ensure treesitter parsers are installed for your file types.

3. **Verify file requirements**:
   - File must have sufficient content (>5 lines in scopes)
   - Must have clear function/class definitions
   - Language must support treesitter scope detection

### Snacks.profiler Not Working

If `snacks.profiler` doesn't appear:

1. **Start profiler manually**:
   ```lua
   :lua require('snacks').profiler.start()
   ```

2. **Check profiler status**:
   ```lua
   :lua print(require('snacks').profiler.enabled)
   ```

3. **View profiler results**:
   ```lua
   :lua require('snacks').profiler.show()
   ```

## Configuration Verification

### Complete Health Check Commands

Run these commands to verify your snacks configuration:

```vim
" Basic health check
:checkhealth snacks

" Detailed plugin inspection
:lua print(vim.inspect(require('snacks').config))

" Check specific plugins
:lua print("Dim enabled:", require('snacks').config.dim.enabled)
:lua print("Profiler enabled:", require('snacks').config.profiler.enabled)
:lua print("Animate enabled:", require('snacks').config.animate.enabled)

" Test functionality
:lua require('snacks').notifier.show("Test notification")
:lua require('snacks').terminal()
```

### Expected Health Check Output

A properly configured snacks.nvim should show:

```
Snacks.nvim health
- OK setup {enabled}
- OK animate {enabled}
- OK bigfile {enabled}
- OK bufdelete {enabled}
- OK dashboard {enabled}
- OK debug {enabled}
- OK dim {enabled}
- OK explorer {enabled}
- OK git {enabled}
- OK gitbrowse {enabled}
- OK health {enabled}
- OK indent {enabled}
- OK input {enabled}
- OK layout {enabled}
- OK lazygit {enabled}
- OK notifier {enabled}
- OK picker {enabled}
- OK profiler {enabled}
- OK quickfile {enabled}
- OK scope {enabled}
- OK scroll {enabled}
- OK statuscolumn {enabled}
- OK terminal {enabled}
- OK words {enabled}
```

## Debugging Steps

1. **Restart Neovim** after configuration changes
2. **Check for conflicting plugins** that might interfere
3. **Verify nvf build** completed successfully
4. **Test in minimal configuration** to isolate issues
5. **Check snacks.nvim version** compatibility

## Getting Help

If issues persist:
1. Run `:checkhealth` for overall Neovim health
2. Check `:messages` for error messages
3. Review the snacks.nvim documentation
4. Report issues with configuration details and error messages