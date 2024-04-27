{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.gitsigns-nvim;
  lazy = true;
  event = "BufRead";
  config = ''
    function()
       require("gitsigns").setup({
       })
    end
  '';
}
