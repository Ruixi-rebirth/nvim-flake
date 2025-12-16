{ pkgs, lib, ... }:
{
  pkg = pkgs.vimPlugins.outline-nvim;
  lazy = true;
  cmd = [
    "Outline"
    "OutlineOpen"
  ];
  keys = lib.nixvim.mkRaw ''
    {
      -- Example mapping to toggle outline
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" }
    }
  '';
  opts = lib.nixvim.mkRaw ''
    {
      outline_window = {
        position = "right",
        width = 25,
      },
      outline_items = {
        show_symbol_lineno = true,
      },
      preview_window = {
        live = true,
      },
    }
  '';
}
