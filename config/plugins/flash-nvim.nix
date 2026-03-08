{ ... }:
{
  plugins.flash = {
    enable = true;

    settings = {
      labels = "asdfghjklqwertyuiopzxcvbnm";
      search = {
        mode = "fuzzy";
      };
      jump = {
        autojump = false;
      };
      label = {
        rainbow = {
          enabled = false;
          shade = 5;
        };
      };
      prompt = {
        enabled = true;
        prefix = [
          [
            "🔎"
            "FlashPromptIcon"
          ]
        ];
      };
    };

    lazyLoad.settings = {
      keys = [
        {
          __unkeyed-1 = "<c-f>";
          __unkeyed-2.__raw = "function() require('flash').jump() end";
          mode = [
            "n"
            "x"
            "o"
          ];
          desc = "Flash";
        }
        {
          __unkeyed-1 = "<leader>t";
          __unkeyed-2.__raw = "function() require('flash').treesitter() end";
          mode = [
            "n"
            "o"
            "x"
          ];
          desc = "Flash Treesitter";
        }
        {
          __unkeyed-1 = "<leader>r";
          __unkeyed-2.__raw = "function() require('flash').remote() end";
          mode = "o";
          desc = "Remote Flash";
        }
        {
          __unkeyed-1 = "<C-s>t";
          __unkeyed-2.__raw = "function() require('flash').treesitter_search() end";
          mode = [
            "o"
            "x"
          ];
          desc = "Flash Treesitter Search";
        }
      ];
    };
  };
}
