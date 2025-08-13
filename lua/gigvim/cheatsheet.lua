-- GigVim Cheatsheet Helper
local M = {}

function M.show()
  local cheatsheet = {
    { category = "File Operations", items = {
      { key = "<leader>ff", desc = "Find Files" },
      { key = "<leader>fb", desc = "Find Buffers" },
      { key = "<leader>fr", desc = "Recent Files" },
      { key = "<leader>fg", desc = "Live Grep" },
      { key = "<leader>fs", desc = "Find Symbols" },
      { key = "<leader>fk", desc = "Find Keymaps" },
      { key = "<leader>fc", desc = "Find Commands" },
      { key = "<leader>e", desc = "Toggle Explorer" },
    }},
    { category = "Git Operations", items = {
      { key = "<leader>gg", desc = "Lazygit" },
      { key = "<leader>gs", desc = "Git Blame Line" },
      { key = "<leader>gf", desc = "Git Files" },
      { key = "<leader>gdo", desc = "Open Remote Repo" },
      { key = "<leader>gdr", desc = "Recent Repos" },
      { key = "<leader>gdc", desc = "Clean Repo" },
    }},
    { category = "Buffer Management", items = {
      { key = "<leader>bd", desc = "Delete Buffer" },
      { key = "<leader>ba", desc = "Delete All Buffers" },
      { key = "<leader>bo", desc = "Delete Other Buffers" },
    }},
    { category = "Themes & Terminal", items = {
      { key = "<leader>th", desc = "Theme Selector" },
      { key = "<leader>tt", desc = "Toggle Theme" },
      { key = "<leader>tf", desc = "Floating Terminal" },
    }},
    { category = "Notifications", items = {
      { key = "<leader>nh", desc = "Notification History" },
      { key = "<leader>nd", desc = "Dismiss Notifications" },
    }},
    { category = "General", items = {
      { key = "jj", desc = "Exit Insert Mode" },
      { key = "q", desc = "Quit (from dashboard)" },
      { key = "d", desc = "Return to Dashboard" },
    }},
  }

  local lines = {
    "# GigVim Cheatsheet",
    "",
    "Press 'q' to return to dashboard",
    "",
  }

  for _, section in ipairs(cheatsheet) do
    table.insert(lines, "## " .. section.category)
    table.insert(lines, "")
    for _, item in ipairs(section.items) do
      table.insert(lines, string.format("%-20s %s", item.key, item.desc))
    end
    table.insert(lines, "")
  end

  -- Create a new buffer for the cheatsheet
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

  -- Open in a floating window
  local width = math.min(80, vim.o.columns - 4)
  local height = math.min(#lines + 2, vim.o.lines - 4)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded',
    title = ' GigVim Cheatsheet ',
    title_pos = 'center',
  })

  -- Set up keybinding to close with 'q'
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':lua Snacks.dashboard()<CR>', { noremap = true, silent = true })
end

return M