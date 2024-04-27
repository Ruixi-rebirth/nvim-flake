{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.trouble-nvim;
  dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
  opts = helpers.mkRaw ''
    {
        icons = {
          indent = {
            middle = " ",
            last = " ",
            top = " ",
            ws = "│  "
          },
        },
        modes = {
          diagnostics = {
            groups = {
              { "filename", format = "{file_icon} {basename:Title} {count}" },
            },
          },
        },
      }'';
  cmd = "Trouble";
  keys = helpers.mkRaw ''
    {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
        { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
        { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
        { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
        { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" }
      }'';
}
