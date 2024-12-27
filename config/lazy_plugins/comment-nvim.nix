{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.comment-nvim;
  lazy = true;
  dependencies = with pkgs.vimPlugins; [ nvim-ts-context-commentstring ];
  event = "BufReadPost";
  config = ''
    function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        padding = true,
        sticky = true,
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        extra = {
          ---Add comment on the line above
          above = "gcO",
          ---Add comment on the line below
          below = "gco",
          ---Add comment at the end of line
          eol = "gcA",
        },

        mappings = {
          basic = true,
          extra = true,
          extended = false,
        },
      })
    end
  '';
}
