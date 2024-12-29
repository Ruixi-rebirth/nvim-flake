{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    vim-nix
  ];
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "vim-nix";
        lazy = true;
        ft = [ "nix" ];
      }
    ];
  };
}
