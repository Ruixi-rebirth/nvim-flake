{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.lualine-nvim;
  lazy = false;
  dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
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
