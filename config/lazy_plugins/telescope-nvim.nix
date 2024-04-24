{ pkgs, helpers, ... }:
with pkgs.vimPlugins; {
  pkg = telescope-nvim;
  lazy = true;
  dependencies = [ plenary-nvim ];
  keys = helpers.mkRaw ''{
    { "<Leader>e", "<cmd>Telescope<CR>", desc = "telescope" },
  }'';
  config = ''
    function()
       require("telescope").setup({
       })
    end
  '';
}
