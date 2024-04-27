{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.nvim-dap-ui;
  lazy = true;
  dependencies = with pkgs.vimPlugins; [
    nvim-nio
  ];
  keys = helpers.mkRaw ''{
    { "<C-b>", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "toggle_breakpoint" }
  }'';
  config = ''
    function()
       require("dapui").setup()
       local sign = vim.fn.sign_define

       sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
       sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
       sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    end
  '';
}
