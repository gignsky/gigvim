# render-markdown.nvim - Markdown rendering in Neovim
# https://github.com/MeanderingProgrammer/render-markdown.nvim

{ inputs, pkgs, ... }:
let
  render-markdown-nvim-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "render-markdown-nvim";
    src = inputs.render-markdown-nvim; # Must match the input name in flake.nix
  };
in
{
  config.vim.extraPlugins = {
    render-markdown-nvim = {
      package = render-markdown-nvim-from-source;
      setup = ''
        require('render-markdown').setup({
          -- Whether or not to show the rendered markdown in normal mode
          enabled = true,
          -- Maximum file size (in MB) that this plugin will attempt to render
          max_file_size = 10.0,
          -- The level of logs to write to file: vim.fn.stdpath('state') .. '/render-markdown.log'
          -- Only intended to be used for plugin development / debugging
          log_level = 'error',
          -- Filetypes this plugin will run on
          file_types = { 'markdown' },
          -- Vim modes where plugin is active
          render_modes = { 'n', 'c' },
          -- Characters that will be used to replace leading spaces
          -- Defaults to a non-breaking space: '\u00A0' (alt+160)
          anti_conceal = {
            enabled = true,
          },
          -- Define how different headings get rendered
          heading = {
            -- Turn on / off heading icon & background rendering
            enabled = true,
            -- Turn on / off any sign column related rendering
            sign = true,
            -- Replaces '#+' of 'atx_h._marker'
            -- The number of '#' in the heading determines the 'level'
            -- The 'level' is used to index into the array using a cycle
            icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
            -- Width of the heading background:
            --  block: width of the heading text
            --  full:  full width of the window
            width = 'full',
            -- Highlight for the heading icon and extends through the entire line
            backgrounds = {
              'RenderMarkdownH1Bg',
              'RenderMarkdownH2Bg',
              'RenderMarkdownH3Bg',
              'RenderMarkdownH4Bg',
              'RenderMarkdownH5Bg',
              'RenderMarkdownH6Bg',
            },
            -- The 'level' is used to index into the array using a clamp
            foregrounds = {
              'RenderMarkdownH1',
              'RenderMarkdownH2',
              'RenderMarkdownH3',
              'RenderMarkdownH4',
              'RenderMarkdownH5',
              'RenderMarkdownH6',
            },
          },
          -- Configuration for block quotes
          quote = {
            -- Turn on / off block quote & callout rendering
            enabled = true,
            -- Replaces '>' of 'block_quote'
            icon = '▋',
            -- Highlight for the quote icon
            highlight = 'RenderMarkdownQuote',
          },
          -- Configuration for checkboxes
          checkbox = {
            -- Turn on / off checkbox state rendering
            enabled = true,
            unchecked = {
              -- Replaces '[ ]' of 'task_list_marker_unchecked'
              icon = '󰄱 ',
              -- Highlight for the unchecked icon
              highlight = 'RenderMarkdownUnchecked',
            },
            checked = {
              -- Replaces '[x]' of 'task_list_marker_checked'
              icon = '󰱒 ',
              -- Highlight for the checked icon
              highlight = 'RenderMarkdownChecked',
            },
          },
          -- Configuration for different bullet levels
          bullet = {
            -- Turn on / off list bullet rendering
            enabled = true,
            -- Replaces '-'|'+'|'*' of 'list_item'
            -- How deeply nested the list is determines the 'level'
            -- The 'level' is used to index into the array using a cycle
            icons = { '●', '○', '◆', '◇' },
            -- Highlight for the bullet icon
            highlight = 'RenderMarkdownBullet',
          },
          -- Configuration for tables
          table = {
            -- Turn on / off table rendering
            enabled = true,
            -- Style to use for tables: full, normal, minimal
            style = 'full',
            -- Highlight for table heading, delimiter, and the line above
            head = 'RenderMarkdownTableHead',
            -- Highlight for everything else, main table rows and the line below
            row = 'RenderMarkdownTableRow',
          },
          -- Configuration for links
          link = {
            -- Turn on / off inline link icon rendering
            enabled = true,
            -- Inlined with 'image' elements
            image = '󰥶 ',
            -- Inlined with 'email_autolink' elements
            email = '󰀓 ',
            -- Inlined with 'uri_autolink' elements
            hyperlink = '󰌹 ',
            -- Applies to the fallback inlined icon
            highlight = 'RenderMarkdownLink',
          },
          -- Configuration for signs
          sign = {
            -- Turn on / off sign rendering
            enabled = true,
            -- Applies to background of sign text
            highlight = 'RenderMarkdownSign',
          },
        })
      '';
    };
  };
}