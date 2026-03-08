{ pkgs, ... }:
{
  plugins.nvim-autopairs = {
    enable = true;
    settings = { };

    lazyLoad.settings = {
      event = [ "InsertEnter" ];
    };
  };
}
