{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.nvim-tree-lua;
  lazy = true;
  dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
  keys = helpers.mkRaw ''{
    { "tt", "<cmd>NvimTreeToggle<cr>", desc = "Toggle nvim-tree" }
  }'';
  config = ''
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
