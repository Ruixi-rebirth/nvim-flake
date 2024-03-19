{ pkgs, helpers, ... }:
with pkgs.vimPlugins; {
  pkg = nvim-dap-go;
  lazy = true;
  ft = [ "go" ];
  config = ''
    function()
       require("dap-go").setup({
          delve = {
             path = "${pkgs.delve}/bin/dlv",
          },
       })
    end
  '';
}
