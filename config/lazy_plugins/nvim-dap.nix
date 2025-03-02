{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.nvim-dap;
  lazy = true;
  keys = helpers.mkRaw ''
    {
      { "<C-b>", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "toggle_breakpoint" }
    }
  '';
  config = ''
    function()
      local sign = vim.fn.sign_define

      sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      local dap = require("dap")
      dap.adapters.lldb = {
        type = "executable",
        command = "${pkgs.lldb}/bin/lldb-dap",
        name = "lldb",
      }

      dap.configurations.rust = {
        {
          name = "Launch",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "''${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }
      dap.configurations.cpp = dap.configurations.rust
    end
  '';
}
