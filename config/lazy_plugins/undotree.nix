{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.undotree;
  lazy = true;
  event = "InsertEnter";
}
