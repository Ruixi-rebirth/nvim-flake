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
      update_focused_file = {
        enable = true;
        update_root = true;
      };
    };

    lazyLoad.settings = {
      before.__raw = ''
        function()
          vim.g.loaded_netrw = 1
          vim.g.loaded_netrwPlugin = 1
          vim.opt.termguicolors = true

          local lzn = require('lz.n')
          lzn.trigger_load({
            'telescope.nvim',
          })
        end
      '';
      keys = [
        {
          __unkeyed-1 = "<leader>g";
          __unkeyed-2.__raw = ''
            function()
              local path = vim.api.nvim_buf_get_name(0)
              if vim.bo.filetype == "NvimTree" then
                local node = require("nvim-tree.api").tree.get_node_under_cursor()
                path = node and node.absolute_path or ""
              end
              if path == "" then path = vim.fn.getcwd() end
              local stat = vim.uv.fs_stat(path)
              if not stat or stat.type ~= "directory" then
                path = vim.fn.fnamemodify(path, ":h")
              end
              require("telescope.builtin").live_grep({ search_dirs = { path } })
            end
          '';
          desc = "Live grep in current directory";
        }
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

  };
}
