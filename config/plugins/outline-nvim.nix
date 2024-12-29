{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    outline-nvim
  ];
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "outline.nvim";
        lazy = true;
        cmd = [
          "Outline"
          "OutlineOpen"
        ];
        keys = [
          {
            __unkeyed-1 = "<leader>o";
            __unkeyed-2 = "<cmd>Outline<cr>";
            desc = "Toggle outline";
          }
        ];
        after = ''
          function()
            require("outline").setup({
              outline_window = {
                position = 'right',
                width = 25,
              },
              outline_items = {
                show_symbol_lineno = true,
              },
              preview_window = {
                live = true,
              }
            })
          end
        '';
      }
    ];
  };
}
