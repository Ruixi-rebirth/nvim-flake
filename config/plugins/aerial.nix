{ ... }:
{
  plugins.aerial = {
    enable = true;

    settings = {
      layout = {
        max_width = [
          40
          0.2
        ];
        width = null;
        min_width = 25;
        default_direction = "prefer_right";
      };
      show_guides = true;
      nav = {
        preview = true;
      };
    };

    lazyLoad.settings = {
      keys = [
        {
          __unkeyed-1 = "<leader>o";
          __unkeyed-2 = "<cmd>AerialNavToggle<cr>";
          desc = "Toggle aerial outline";
        }
      ];
    };
  };
}
