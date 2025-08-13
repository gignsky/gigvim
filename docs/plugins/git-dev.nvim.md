# git-dev.nvim - Remote Git Repository Integration

Open remote Git repositories inside Neovim by managing ephemeral shallow clones automatically. Provides a GitHub.dev-like experience directly within Neovim.

## Features

- **Remote Repository Access**: Open any public Git repository directly in Neovim
- **Ephemeral Clones**: Automatically manages temporary shallow clones
- **Smart URL Parsing**: Supports GitHub, GitLab, Gitea, and Codeberg URLs
- **Branch/Tag/Commit Support**: Open repositories at specific references
- **File Navigation**: Jump directly to specific files from URLs
- **Telescope Integration**: Browse and reopen previously accessed repositories
- **XDG Integration**: Handle `nvim-gitdev://` URLs from browsers

## Configuration

The plugin is configured with sensible defaults:

```lua
require('git-dev').setup({
  ephemeral = true,           -- Delete repos when Neovim exits
  read_only = true,           -- Set buffers to read-only
  cd_type = "global",         -- Change directory globally
  repositories_dir = vim.fn.stdpath("cache") .. "/git-dev",
  
  git = {
    command = "git",
    base_uri_format = "https://github.com/%s.git",
    clone_args = "--jobs=2 --single-branch --recurse-submodules --shallow-submodules --progress",
  },
  
  ui = {
    enabled = true,
    auto_close = true,
    close_after_ms = 3000,
    mode = "floating",
  },
})
```

## Usage

### Commands

- `:GitDevOpen <repo>` - Open a remote repository
- `:GitDevCloseBuffers` - Close all buffers for current repository
- `:GitDevClean` - Clean current repository (close buffers + delete)
- `:GitDevCleanAll` - Clean all cached repositories
- `:GitDevRecents` - Browse recent repositories with Telescope
- `:GitDevToggleUI` - Toggle the git-dev output window

### Examples

#### Basic Repository Opening
```vim
" Open a repository by name (uses GitHub by default)
:GitDevOpen moyiz/git-dev.nvim

" Open at specific branch
:GitDevOpen derailed/k9s {branch="main"}

" Open at specific tag
:GitDevOpen derailed/k9s {tag="v0.32.4"}

" Open at specific commit
:GitDevOpen nvim-tree/nvim-tree.lua {commit="abc123"}
```

#### Full URLs
```vim
" GitHub URLs
:GitDevOpen https://github.com/echasnovski/mini.nvim
:GitDevOpen https://github.com/echasnovski/mini.nvim/blob/main/README.md

" GitLab URLs
:GitDevOpen https://gitlab.com/gitlab-org/gitlab

" Gitea/Codeberg URLs
:GitDevOpen https://codeberg.org/forgejo/forgejo
```

#### Lua API
```lua
-- Basic opening
require("git-dev").open("moyiz/git-dev.nvim")

-- With specific reference
require("git-dev").open("derailed/k9s", { tag = "v0.32.4" })

-- With options override
require("git-dev").open("echasnovski/mini.nvim", 
  { branch = "stable" }, 
  { ephemeral = false })

-- Parse a URL
local parsed = require("git-dev").parse("https://github.com/user/repo/blob/main/file.lua")
```

## URL Parsing

The plugin intelligently parses various Git hosting service URLs:

### Supported URL Formats

#### GitHub
- `https://github.com/user/repo`
- `https://github.com/user/repo/tree/branch`
- `https://github.com/user/repo/blob/branch/file.lua`
- `https://github.com/user/repo/blob/tag/file.lua`

#### GitLab
- `https://gitlab.com/user/repo`
- `https://gitlab.com/user/repo/-/tree/branch`
- `https://gitlab.com/user/repo/-/blob/branch/file.lua`

#### Gitea/Codeberg
- `https://gitea.com/user/repo`
- `https://gitea.com/user/repo/src/branch/branch-name`
- `https://gitea.com/user/repo/src/tag/tag-name/file.lua`
- `https://gitea.com/user/repo/src/commit/commit-hash/file.lua`

### Automatic Extraction

When opening URLs, the plugin automatically extracts:
- Repository URL for cloning
- Target branch, tag, or commit
- Specific file path (if present)
- Opens the file directly if specified

## Telescope Integration

Access recently opened repositories:

```vim
" Browse recent repositories
:GitDevRecents

" Or using Telescope directly
:Telescope git_dev recents
```

The telescope picker shows:
- Repository names and URLs
- Last access time
- Quick actions to reopen

## Repository Management

### Ephemeral Repositories
By default, repositories are ephemeral and automatically cleaned up when Neovim exits. This keeps your cache directory clean and saves disk space.

### Manual Cleanup
```vim
" Clean current repository
:GitDevClean

" Clean all repositories
:GitDevCleanAll

" Close buffers without cleaning
:GitDevCloseBuffers
```

### Persistent Repositories
For repositories you want to keep:
```lua
require("git-dev").open("user/repo", {}, { ephemeral = false })
```

## Advanced Usage

### Custom Opener
Customize how repositories are opened:
```lua
require('git-dev').setup({
  opener = function(dir, repo_uri, selected_path)
    -- Open in new tab
    vim.cmd("tabnew")
    
    -- Use file explorer
    vim.cmd("Neotree " .. dir)
    
    -- Open specific file if provided
    if selected_path then
      vim.cmd("edit " .. dir .. "/" .. selected_path)
    end
  end,
})
```

### Custom Git Configuration
```lua
require('git-dev').setup({
  git = {
    default_org = "myorg",  -- Default organization for short names
    base_uri_format = "git@github.com:%s.git",  -- Use SSH
  },
})
```

### Private Repositories
For private repositories, configure SSH or custom authentication:
```lua
require('git-dev').setup({
  git = {
    base_uri_format = "git@github.com:%s.git",
  },
})
```

## Key Bindings Example

Add convenient key bindings:
```lua
-- In your Neovim configuration
vim.keymap.set('n', '<leader>go', function()
  local repo = vim.fn.input("Repository: ")
  if repo ~= "" then
    require("git-dev").open(repo)
  end
end, { desc = "Open remote git repository" })

vim.keymap.set('n', '<leader>gr', ':GitDevRecents<CR>', { desc = "Recent git repositories" })
vim.keymap.set('n', '<leader>gc', ':GitDevClean<CR>', { desc = "Clean current git repository" })
```

## Browser Integration

For seamless browser-to-Neovim workflow, git-dev.nvim supports XDG handling of custom URIs.

### Setup
Enable XDG handling:
```lua
require('git-dev').setup({
  xdg_handler = {
    enabled = true,
  },
})
```

This registers `nvim-gitdev://` URLs to open in Neovim.

### Browser Extensions
Create bookmarklets or browser extensions to send current page to Neovim:
```javascript
// Bookmarklet
javascript:(function(){window.open('nvim-gitdev://open/?repo=' + encodeURIComponent(window.location.href))})()
```

## Benefits

- **Quick Exploration**: Instantly browse any public repository
- **No Local Setup**: No need to clone repositories manually
- **Efficient Workflow**: Seamless transition from browser to editor
- **Storage Efficient**: Automatic cleanup of temporary repositories
- **Integrated Experience**: Full Neovim features (LSP, treesitter, etc.)
- **Historical Access**: Easy access to previously viewed repositories

## Use Cases

- **Code Review**: Quickly examine pull requests and commits
- **Learning**: Explore open source projects and code examples
- **Reference**: Look up implementation details in other projects
- **Documentation**: Read source code alongside documentation
- **Debugging**: Investigate issues in dependencies
- **Research**: Study different approaches and patterns

## Tips

1. **Short Names**: Use short names like `user/repo` for GitHub repositories
2. **Branch Navigation**: Open specific branches to see different implementations
3. **File URLs**: Copy file URLs from GitHub to open files directly
4. **History**: Use `:GitDevRecents` to revisit interesting repositories
5. **Cleanup**: Regularly run `:GitDevCleanAll` if you explore many repositories
6. **Read-Only**: Repositories are read-only by default to prevent accidental changes
7. **Integration**: Combine with your favorite file explorer for better navigation