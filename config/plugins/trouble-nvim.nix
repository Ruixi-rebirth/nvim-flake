{ ... }:
{
  plugins.trouble = {
    enable = true;

    settings = {
      icons = {
        indent = {
          middle = " ";
          last = " ";
          top = " ";
          ws = "│  ";
        };
      };
      modes = {
        diagnostics = {
          groups = [
            {
              __unkeyed-1 = "filename";
              format = "{file_icon} {basename:Title} {count}";
            }
          ];
        };
      };
    };

    lazyLoad.settings = {
      cmd = [ "Trouble" ];
      keys = [
        {
          __unkeyed-1 = "<leader>xx";
          __unkeyed-2 = "<cmd>Trouble diagnostics toggle<cr>";
          desc = "Diagnostics (Trouble)";
        }
        {
          __unkeyed-1 = "<leader>xX";
          __unkeyed-2 = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
          desc = "Buffer Diagnostics (Trouble)";
        }
        {
          __unkeyed-1 = "<leader>cs";
          __unkeyed-2 = "<cmd>Trouble symbols toggle focus=false<cr>";
          desc = "Symbols (Trouble)";
        }
        {
          __unkeyed-1 = "<leader>cl";
          __unkeyed-2 = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
          desc = "LSP Definitions / references / ... (Trouble)";
        }
        {
          __unkeyed-1 = "<leader>xL";
          __unkeyed-2 = "<cmd>Trouble loclist toggle<cr>";
          desc = "Location List (Trouble)";
        }
        {
          __unkeyed-1 = "<leader>xQ";
          __unkeyed-2 = "<cmd>Trouble qflist toggle<cr>";
          desc = "Quickfix List (Trouble)";
        }
      ];
    };
  };
}
