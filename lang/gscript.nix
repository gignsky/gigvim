{ pkgs, ... }:
{
  config.vim.languages.nu = {
    enable = true;
    lsp = {
      enable = true;
    };

    # 🌟 NEW ADDITION: Inject the gscript Lua commands here 🌟
    # This leverages the existing 'nu' language module's 'extraConfigLua',
    # which we know the system accepts.
    extraConfigLua = ''
      -- 1. Filetype Detection: Assign .gscript to 'gscriptstring' filetype
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = '*.gscript',
        callback = function()
          -- Set the filetype to a unique, custom name
          vim.bo.filetype = 'gscriptstring'
        end,
        desc = 'Set filetype for .gscript to gscriptstring',
      })

      -- 2. Syntax-Spoiling Configuration: Treat 'gscriptstring' as a Rust String
      vim.api.nvim_create_autocmd({ 'FileType' }, {
        pattern = 'gscriptstring',
        callback = function()
          -- Clear any existing syntax for this buffer
          vim.cmd 'syntax clear'
          
          -- Load the syntax file for Rust to gain access to the 'String' group
          vim.cmd 'runtime syntax/rust.vim'
          
          -- Define a syntax region that spans the entire buffer
          vim.cmd 'syntax region gscriptStringBody start=/^/ end=/$/'

          -- Link our custom highlight group to the standard 'String' highlight group
          vim.cmd 'highlight link gscriptStringBody String'
        end,
        desc = 'Apply String-like syntax to gscriptstring filetype',
      })
    '';
  };
}
