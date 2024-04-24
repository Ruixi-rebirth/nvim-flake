{ pkgs, ... }:
with pkgs.vimPlugins; {
  pkg = gitsigns-nvim;
  lazy = true;
  event = "BufRead";
  config = ''
    function()
       require("gitsigns").setup({
       })
    end
  '';
}
