{ pkgs, ... }:
{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "auto";
        globalstatus = true;
      };
    };
  };
}
