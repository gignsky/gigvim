
    # Lua configuration
    require('plugin').setup({
      option = true,
      callback = function()
        vim.notify("Plugin loaded")
      end
    })
    
