{ pkgs, ... }:
with pkgs.vimPlugins; {
  pkg = undotree;
  lazy = true;
  event = "InsertEnter";
}
