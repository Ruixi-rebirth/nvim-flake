{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.nord-nvim;
  lazy = false;
  priority = 1000;
  init = ''
    function()
      vim.g.nord_contrast = false
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_enable_sidebar_background = true
      vim.g.nord_bold = true
      vim.g.nord_cursorline_transparent = false
    end
  '';
  config = ''
    function()
      require("nord").set()
      local colors = require('nord.colors')
      local highlights = {
        LspInlayHint = { fg = colors.nord3_gui_bright, style = 'italic' }, -- nvim-lspconfig
        -- CmpItemAbbr = { fg = colors.nord3_gui_bright }, -- nvim-cmp

        _BlinkCmpMenu = { fg = colors.nord14_gui },
        _BlinkCmpMenuBorder = { bg = NONE },
        _BlinkCmpMenuSelection = { bg = colors.nord10_gui },
        BlinkCmpKindCopilot = { fg = "#6CC644" },
        BlinkCmpLabelMatch = { fg = colors.nord5_gui, style = 'bold' },
        BlinkCmpSource = { fg = colors.nord15_gui },
        BlinkCmpLabel = { fg = colors.nord3_gui_bright, style = 'italic' },
        BlinkCmpKind = { fg = colors.nord14_gui },
      }
      for group, opts in pairs(highlights) do
        require('nord.util').highlight(group, opts)
      end
    end
  '';
}
