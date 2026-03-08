{ pkgs, ... }:
{
  colorschemes.nord = {
    enable = true;
    settings = {
      contrast = false;
      borders = true;
      disable_background = false;
      italic = true;
      uniform_diff_background = true;
      enable_sidebar_background = true;
      bold = true;
      cursorline_transparent = false;
    };
  };

  # Using extraConfigLuaPost to ensure highlights are applied after the colorscheme is set
  extraConfigLuaPost = ''
    local colors = require('nord.colors')
    local highlights = {
      LspInlayHint = { fg = colors.nord3_gui_bright, style = 'italic' },
      _BlinkCmpMenu = { fg = colors.nord14_gui },
      _BlinkCmpMenuBorder = { bg = "NONE" },
      _BlinkCmpMenuSelection = { bg = colors.nord10_gui },
      BlinkCmpKindCopilot = { fg = "#6CC644" },
      BlinkCmpKindMinuet = { fg = "#6CC644" },
      BlinkCmpLabelMatch = { fg = colors.nord5_gui, style = 'bold' },
      BlinkCmpSource = { fg = colors.nord15_gui },
      BlinkCmpLabel = { fg = colors.nord3_gui_bright, style = 'italic' },
      BlinkCmpKind = { fg = colors.nord14_gui },
    }
    for group, opts in pairs(highlights) do
      require('nord.util').highlight(group, opts)
    end
  '';
}
