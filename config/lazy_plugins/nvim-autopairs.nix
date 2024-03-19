{ pkgs, ... }:
with pkgs.vimPlugins; {
  pkg = nvim-autopairs;
  lazy = true;
  event = "InsertEnter";
  config = ''
    function()
       require("nvim-autopairs").setup {}
    end
  '';
}
