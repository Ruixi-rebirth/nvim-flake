{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.trouble-nvim;
  lazy = true;
  dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
  keys = helpers.mkRaw ''{
    { "tr", "<cmd>TroubleToggle<cr>>", desc = "toggle trouble" }
  }'';
}
