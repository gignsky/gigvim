-- GigVim Checkhealth Menu Helper
local M = {}

function M.menu()
  local health_options = {
    { key = "1", desc = "Check Snacks.nvim", command = ":checkhealth snacks" },
    { key = "2", desc = "Check LSP", command = ":checkhealth vim.lsp" },
    { key = "3", desc = "Check Treesitter", command = ":checkhealth nvim-treesitter" },
    { key = "4", desc = "Check General", command = ":checkhealth" },
    { key = "5", desc = "Check Git", command = ":checkhealth git" },
    { key = "6", desc = "Check Provider", command = ":checkhealth provider" },
    { key = "q", desc = "Return to Dashboard", command = ":lua Snacks.dashboard()" },
  }

  local lines = {
    "# Health Check Menu",
    "",
    "Select a health check to run:",
    "",
  }

  for _, option in ipairs(health_options) do
    table.insert(lines, string.format("%s - %s", option.key, option.desc))
  end

  table.insert(lines, "")
  table.insert(lines, "Press the corresponding number or 'q' to return")

  -- Create a new buffer for the menu
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

  -- Open in a floating window
  local width = math.min(60, vim.o.columns - 4)
  local height = math.min(#lines + 2, vim.o.lines - 4)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded',
    title = ' Health Check Menu ',
    title_pos = 'center',
  })

  -- Set up keybindings for each option
  for _, option in ipairs(health_options) do
    vim.api.nvim_buf_set_keymap(buf, 'n', option.key, option.command .. '<CR>', { noremap = true, silent = true })
  end
end

return M