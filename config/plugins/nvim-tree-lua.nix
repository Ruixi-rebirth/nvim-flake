{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    nvim-tree-lua
  ];
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "nvim-tree.lua";
        lazy = true;
        keys = [
          {
            __unkeyed-1 = "tt";
            __unkeyed-2 = "<cmd>NvimTreeToggle<cr>";
            desc = "Toggle nvim-tree";
          }
        ];
        after = ''
          function()
             vim.g.loaded_netrw = 1
             vim.g.loaded_netrwPlugin = 1
             vim.opt.termguicolors = true
             require("nvim-tree").setup({
                sort_by = "case_sensitive",
                renderer = {
                   group_empty = true,
                },
                filters = {
                   dotfiles = true,
                },
                view = {
                   width = 25,
                   side = "left",
                },
             })
          end
        '';
      }
    ];
  };
}
