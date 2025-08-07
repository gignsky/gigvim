{ lib, ... }:
{
  config.vim.statusline.lualine = {
    enable = true;
    # setupOpts = {
    #   sections = {
    #     lualine_b = [
    #       (lib.generators.mkLuaInline ''
    #         {
    #           "filetype",
    #           colored = true,
    #           icon_only = true,
    #           icon = { align = 'left' }
    #         }
    #       '')
    #       (lib.generators.mkLuaInline ''
    #         {
    #           function()
    #             local path = vim.fn.expand('%:p')
    #             if path == "" then
    #               return "[No Name]"
    #             end
    #
    #             -- Get relative path from current working directory
    #             local cwd = vim.fn.getcwd()
    #             if path:sub(1, #cwd) == cwd then
    #               path = path:sub(#cwd + 2) -- Remove cwd and leading slash
    #             end
    #
    #             -- Split path into parts
    #             local parts = {}
    #             for part in path:gmatch("[^/]+") do
    #               table.insert(parts, part)
    #             end
    #
    #             -- If path is short, return just filename for very short paths
    #             if #parts <= 2 then
    #               return parts[#parts]
    #             end
    #
    #             -- Create smart abbreviated path
    #             local result = {}
    #             for i = 1, #parts - 1 do
    #               if i == #parts - 1 then
    #                 -- Keep the immediate parent directory full
    #                 table.insert(result, parts[i])
    #               else
    #                 -- Abbreviate other directories to first character
    #                 table.insert(result, parts[i]:sub(1, 1))
    #               end
    #             end
    #
    #             table.insert(result, parts[#parts]) -- filename
    #
    #             return table.concat(result, "/")
    #           end,
    #           symbols = {modified = ' ', readonly = ' '},
    #           separator = {right = ''}
    #         }
    #       '')
    #       (lib.generators.mkLuaInline ''
    #         {
    #           "",
    #           draw_empty = true,
    #           separator = { left = '', right = '' }
    #         }
    #       '')
    #     ];
    #   };
    # };
    theme = "gruvbox";
  };
}
