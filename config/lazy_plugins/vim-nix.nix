{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.vim-nix;
  lazy = true;
  ft = [ "nix" ];
  config = '''';
}
