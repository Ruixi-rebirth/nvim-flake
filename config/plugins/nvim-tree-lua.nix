{ ... }:
{
  plugins.nvim-tree = {
    enable = true;

    settings = {
      sort_by = "case_sensitive";
      renderer = {
        group_empty = true;
      };
      filters = {
        dotfiles = true;
      };
      view = {
        width = 25;
        side = "left";
      };
    };

    lazyLoad.settings = {
      before.__raw = ''
        function()
          vim.g.loaded_netrw = 1
          vim.g.loaded_netrwPlugin = 1
          vim.opt.termguicolors = true
        end
      '';
      keys = [
        {
          __unkeyed-1 = "tt";
          __unkeyed-2 = "<cmd>NvimTreeToggle<cr>";
          desc = "Toggle nvim-tree";
        }
        {
          __unkeyed-1 = "gF";
          __unkeyed-2 = "<cmd>NvimTreeFindFileToggle<cr>";
          desc = "Jump to current file's directory";
        }
      ];

    };

    luaConfig.post = ''
      -- Telescope integration for searching inside the folder under the cursor
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
    '';
  };
}
