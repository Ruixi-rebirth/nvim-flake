{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.nvim-surround;
  lazy = true;
  event = "BufReadPost";
  config = ''
    function()
       require("nvim-surround").setup()
    end
  '';
}
