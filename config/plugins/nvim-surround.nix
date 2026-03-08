{ pkgs, ... }:
{
  plugins.nvim-surround = {
    enable = true;
    settings = { };

    lazyLoad.settings = {
      event = [ "BufReadPost" ];
    };
  };
}
