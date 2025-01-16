{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.telescope-nvim;
  lazy = true;
  dependencies = with pkgs.vimPlugins; [ plenary-nvim ];
  keys = helpers.mkRaw ''
    {
      { "<Leader>e", "<cmd>Telescope<CR>", desc = "telescope" },
    }
  '';
  config = ''
    function()
      require("telescope").setup({})
    end
  '';
}
