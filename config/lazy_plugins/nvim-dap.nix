{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.nvim-dap;
  lazy = true;
  keys = helpers.mkRaw ''
    {
        { "<F6>", "<cmd>lua require('dapui').toggle()<CR>", desc = "dapui_toggle" }
      }'';
  config = ''
    function()
       local dap = require("dap")
       dap.adapters.lldb = {
          type = 'executable',
          command = '${pkgs.lldb}/bin/lldb-vscode',
          name = 'lldb'
       }

       dap.configurations.rust = {
          {
             name = 'Launch',
             type = 'lldb',
             request = 'launch',
             program = function()
             return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
             end,
             cwd = "''${workspaceFolder}",
             stopOnEntry = false,
             args = {},
          },
       }
    end
  '';
}
