{ pkgs, ... }:
with pkgs.vimPlugins; {
  pkg = nvim-surround;
  lazy = true;
  event = "BufReadPost";
  config = ''
    function()
       require("nvim-surround").setup()
    end
  '';
}
