{ pkgs, helpers, ... }:
with pkgs.vimPlugins; {
  pkg = vim-nix;
  lazy = true;
  ft = [ "nix" ];
  config = ''
  '';
}
