{ lib, ... }:
{
  config.vim.mini = {
    ai.enable = false;
    align.enable = false;
    bracketed.enable = false;
    comment.enable = false;
    diff.enable = false;
    files.enable = false;
    git.enable = false;
    icons.enable = false;
    indentscope = {
      enable = false;
      setupOpts.draw.animation = lib.generators.mkLuaInline ''require("mini.indentscope").gen_animation.none()'';
    };
    jump2d = {
      enable = true;
      setupOpts = {
        labels = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        mappings.start_jumping = "<leader>j";
        view.dim = true;
        silent = true;
      };
    };
    move.enable = false;
    notify.enable = false;
    operators.enable = false;
    pairs.enable = false;
    splitjoin.enable = false;
    starter.enable = false;
    statusline.enable = false;
    surround.enable = true;
    tabline.enable = true;
    trailspace.enable = false;
  };
}
