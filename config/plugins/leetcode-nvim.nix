{ ... }:
{
  plugins.leetcode = {
    enable = true;

    settings = {
      lang = "golang";
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
