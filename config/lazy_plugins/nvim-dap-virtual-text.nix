{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.nvim-dap-virtual-text;
  lazy = true;
  dependencies = with pkgs.vimPlugins; [ nvim-dap ];
  config = ''
    function()
      require("nvim-dap-virtual-text").setup()
    end
  '';
}
