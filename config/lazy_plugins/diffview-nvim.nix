{ pkgs, ... }:
with pkgs.vimPlugins; {
  pkg = diffview-nvim;
  lazy = false;
  config = ''
  '';
}
