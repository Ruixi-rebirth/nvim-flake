{ ... }:
{
  plugins.telescope = {
    enable = true;
    settings = { };

    lazyLoad.settings = {
      keys = [
        {
          __unkeyed-1 = "<leader>e";
          __unkeyed-2 = "<cmd>Telescope<cr>";
          desc = "Telescope";
        }
      ];
    };
  };
}
