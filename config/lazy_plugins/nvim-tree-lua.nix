{ pkgs, lib, ... }:
{
  pkg = pkgs.vimPlugins.nvim-tree-lua;
  lazy = true;
  dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
  keys = lib.nixvim.mkRaw ''
    {
      { "tt", "<cmd>NvimTreeToggle<cr>", desc = "Toggle nvim-tree" },
      { "gF", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Jump to current file's directory" }
    }
  '';
  init = ''
    function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.opt.termguicolors = true
    end
  '';
  config = ''
    function()
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
      -- with telescope
      vim.keymap.set("n", "<leader>g", function()
        local api = require("nvim-tree.api")
        local node = api.tree.get_node_under_cursor()
        local path = node and node.absolute_path or vim.loop.cwd()

        local stat = vim.loop.fs_stat(path)
        if stat and stat.type == "file" then
          path = vim.fn.fnamemodify(path, ":h")
        end

        require("telescope.builtin").live_grep({
          search_dirs = { path },
        })
      end, { desc = "Live grep under current folder from nvim-tree" })
    end
  '';
}
