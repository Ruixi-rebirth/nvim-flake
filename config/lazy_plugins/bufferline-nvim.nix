{ pkgs, ... }:
with pkgs.vimPlugins; {
  pkg = bufferline-nvim;
  lazy = false;
  dependencies = [ nvim-web-devicons ];
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
