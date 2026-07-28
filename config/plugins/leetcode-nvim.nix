{ ... }:
{
  plugins.leetcode = {
    enable = true;

    settings = {
      lang = "golang";

      injector = {
        __raw = ''
          {
            golang = {
              before = { "package main" },
            },
          }
        '';
      };

      cn = {
        enabled = true;
        translator = true;
        translate_problems = true;
      };
      storage = {
        home = "~/Codelearning/leetcode";
        cache = "~/Codelearning/leetcode/cache";
      };
      picker.provider = "telescope";
      image_support = true;

      console = {
        open_on_runcode = true;
        dir = "row";
        size = {
          width = "90%";
          height = 15;
        };
        result = {
          size = "60%";
        };
      };
    };

    lazyLoad.settings = {
      cmd = [ "Leet" ];
      before.__raw = ''
        function()
          local lzn = require('lz.n')
          lzn.trigger_load({ 'telescope.nvim', 'image.nvim' })
          local home = vim.fn.expand("~/Codelearning/leetcode")
          vim.fn.mkdir(home, "p")
          if vim.fn.filereadable(home .. "/go.mod") == 0 then
            vim.fn.system({ "go", "mod", "init", "-C", home, "leetcode" })
          end
        end
      '';
      keys = [
        {
          __unkeyed-1 = "<leader>ll";
          __unkeyed-2 = "<cmd>Leet<cr>";
          desc = "LeetCode";
        }
      ];
    };
  };
}
