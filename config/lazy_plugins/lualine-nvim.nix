{ pkgs, ... }:
with pkgs.vimPlugins; {
  pkg = lualine-nvim;
  lazy = false;
  dependencies = [ nvim-web-devicons ];
  config = ''
    function()
       require('lualine').setup({
          options = {
             theme = 'auto',
             globalstatus = true,
          }
       })
    end
  '';
}
