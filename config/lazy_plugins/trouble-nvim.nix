{ pkgs, helpers, ... }:
with pkgs.vimPlugins; {
  pkg = trouble-nvim;
  lazy = true;
  dependencies = [ nvim-web-devicons ];
  keys = helpers.mkRaw ''{
    { "tr", "<cmd>TroubleToggle<cr>>", desc = "toggle trouble" }
  }'';
}
