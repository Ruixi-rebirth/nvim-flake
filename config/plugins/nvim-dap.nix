{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    nvim-dap
    nvim-dap-go
    nvim-dap-virtual-text
    nvim-dap-ui
    nvim-nio
  ];
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "nvim-dap";
        lazy = true;
        keys = [
          {
            __unkeyed-1 = "<C-b>";
            __unkeyed-2 = "<cmd>lua require'dap'.toggle_breakpoint()<cr>";
            desc = "toggle_breakpoint";
          }
        ];
        after = ''
          function()
            local dap = require("dap")
            local sign = vim.fn.sign_define

            sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
            dap.adapters.lldb = {
              type = "executable",
              command = "${pkgs.lldb}/bin/lldb-vscode",
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
          end
        '';
      }
      {
        __unkeyed-1 = "nvim-dap-virtual-text";
        lazy = true;
        before = ''
          function()
            require('lz.n').trigger_load('nvim-dap')
          end
        '';
        after = ''
          function()
            require("nvim-dap-virtual-text").setup()
          end
        '';
      }
      {
        __unkeyed-1 = "nvim-dap-go";
        lazy = true;
        ft = [ "go" ];
        before = ''
          function()
            require('lz.n').trigger_load('nvim-dap')
          end
        '';
        after = ''
          function()
            require("dap-go").setup({
              delve = {
                path = "${pkgs.delve}/bin/dlv",
              },
            })
          end
        '';
      }
      {
        __unkeyed-1 = "nvim-dap-ui";
        lazy = true;
        keys = [
          {
            __unkeyed-1 = "<F6>";
            __unkeyed-2 = "<cmd>lua require('dapui').toggle()<cr>";
            desc = "dapui_toggle";
          }
        ];
        before = ''
          function()
            require('lz.n').trigger_load({'nvim-dap','nvim-nio'})
          end
        '';
        after = ''
          function()
            require("dapui").setup()
          end
        '';
      }
    ];
  };
}
