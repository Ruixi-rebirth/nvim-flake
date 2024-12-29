{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    telescope-nvim
  ];
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "telescope.nvim";
        lazy = true;
        keys = [
          {
            __unkeyed-1 = "<leader>e";
            __unkeyed-2 = "<cmd>Telescope<cr>";
            desc = "Toggle telescope";
          }
        ];
        after = ''
          function()
            require("telescope").setup({})
          end
        '';
      }
    ];
  };
}
