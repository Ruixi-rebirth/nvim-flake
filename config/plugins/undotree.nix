{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    undotree
  ];
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "undotree";
        lazy = true;
        event = "InsertEnter";
      }
    ];
  };
}
