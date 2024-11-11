{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.outline-nvim;
  lazy = true;
  cmd = [ "Outline" "OutlineOpen" ];
  keys = helpers.mkRaw ''{
    -- Example mapping to toggle outline
    { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" }
  }'';
  opts = helpers.mkRaw '' { 
    outline_window = {
      position = 'right',
      width = 25,
    },
  }'';
}
