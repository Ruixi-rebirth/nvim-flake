{ pkgs, lib, ... }:
{
  pkg = pkgs.vimPlugins.nvim-dap-ui;
  lazy = true;
  dependencies = with pkgs.vimPlugins; [
    nvim-nio
  ];
  keys = lib.nixvim.mkRaw ''
    {
      { "<F6>", "<cmd>lua require('dapui').toggle()<CR>", desc = "dapui_toggle" }
    }
  '';
  config = ''
    function()
      require("dapui").setup()
    end
  '';
}
