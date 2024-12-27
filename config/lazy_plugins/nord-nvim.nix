{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.nord-nvim;
  lazy = false;
  priority = 1000;
  config = ''
    function()
      vim.g.nord_contrast = false
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_enable_sidebar_background = true
      vim.g.nord_bold = true
      vim.g.nord_cursorline_transparent = false
      require("nord").set()
      local colors = require('nord.colors')
      local highlights = {
        LspInlayHint = { fg = colors.nord3_gui_bright, style = 'italic' },
        CmpItemAbbr = { fg = colors.nord3_gui_bright },
      }
      for group, opts in pairs(highlights) do
        require('nord.util').highlight(group, opts)
      end
    end
  '';
}
