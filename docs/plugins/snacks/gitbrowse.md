# Git Browse - Open Files in Browser

Quickly open Git repositories, commits, and files in your web browser.

## Features

- **Repository Browsing**: Open current repository in browser
- **File Navigation**: Open specific files at current line
- **Commit Viewing**: Browse commits and diffs online
- **Branch Support**: Works with different branches and remotes
- **Multi-Platform**: Supports GitHub, GitLab, Bitbucket, and more

## Configuration

```lua
gitbrowse = { 
  enabled = true,
  remote = "origin",     -- Default remote to use
  branch = nil,          -- Default branch (nil = current)
}
```

## Usage

### Lua API
Access GitBrowse functionality through Lua:

- `:lua Snacks.gitbrowse()` - Open current file in browser (Keybind: `<leader>go`)
- `:lua Snacks.gitbrowse({ type = "repo" })` - Open repository root
- `:lua Snacks.gitbrowse({ type = "blame" })` - Open file with blame view
- `:lua Snacks.gitbrowse({ type = "commit" })` - Open current commit

### Keybindings
- `<leader>go` - Open current file/repo in browser

### Visual Mode
- Select lines in visual mode and use `<leader>go` to open file at those lines
- Highlights the selected range in the browser

## Supported Platforms

- **GitHub**: github.com repositories
- **GitLab**: gitlab.com and self-hosted instances
- **Bitbucket**: bitbucket.org repositories
- **Azure DevOps**: dev.azure.com repositories
- **Custom**: Configurable URL patterns

## Benefits

- **Quick Sharing**: Easily share code with others
- **Web Features**: Access web-only features like PR reviews
- **Context Preservation**: Opens at exact line/commit
- **Team Collaboration**: Quick links for code discussions

## Examples

```vim
" Open current file at current line
:GitBrowse

" Open repository root
:GitBrowse!

" Open specific commit
:GitBrowse abc123

" Open file blame view
:GitBrowse blame
```