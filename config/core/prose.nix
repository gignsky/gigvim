{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;

  # Filetypes whose buffers hold prose rather than code. In these, a line break
  # is the author's punctuation -- placed at a clause or a sentence end -- and
  # nothing but the author should move one.
  proseFiletypes = [
    "asciidoc"
    "context"
    "markdown"
    "org"
    "plaintex"
    "rmd"
    "rst"
    "tex"
    "text"
    "typst"
  ];
in
{
  config.vim = {
    augroups = [
      {
        name = "gigvimProse";
        clear = true;
      }
    ];

    autocmds = [
      {
        event = [ "FileType" ];
        pattern = proseFiletypes;
        group = "gigvimProse";
        desc = "Never let the editor insert a line break into prose";
        callback = mkLuaInline ''
          function()
            -- 't' auto-wraps prose and 'c' auto-wraps comments, both at
            -- 'textwidth', while you are still typing -- so editing a sentence
            -- in the middle of a paragraph silently chops the line the moment
            -- it crosses the limit.
            --
            -- This has to be a FileType autocmd rather than a global option:
            -- Neovim's own ftplugin/markdown.vim does "setlocal
            -- formatoptions+=tcqln", which would undo a global setting. nvf
            -- registers its autocmds from init.lua, after the runtime ftplugins
            -- have been sourced, so this runs last and wins.
            vim.opt_local.formatoptions:remove("t")
            vim.opt_local.formatoptions:remove("c")

            -- 'textwidth' is deliberately left alone. With 't' gone it no
            -- longer wraps anything by itself, and it still gives "gq" a
            -- sensible width on the rare occasion a reflow is actually wanted.

            -- Wrapping becomes a display concern only: fold long lines in the
            -- window, indent the folded part under the paragraph, never touch
            -- the bytes on disk. ('wrap' and 'linebreak' are already on.)
            vim.opt_local.breakindent = true
          end
        '';
      }
    ];
  };
}
