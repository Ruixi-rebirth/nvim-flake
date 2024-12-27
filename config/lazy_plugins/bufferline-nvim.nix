{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.bufferline-nvim;
  lazy = false;
  dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
  config = ''
    function()
      local highlights
      highlights = require("nord").bufferline.highlights({
        italic = true,
        bold = true,
      })
      require("bufferline").setup({
        highlights = highlights,
      })
    end
  '';
}
