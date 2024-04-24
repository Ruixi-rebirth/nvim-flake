{ pkgs, helpers, ... }:
with pkgs.vimPlugins; {
  pkg = nvim-dap-virtual-text;
  lazy = true;
  dependencies = [ nvim-dap ];
  config = ''
    function()
      require("nvim-dap-virtual-text").setup()
    end
  '';
}
