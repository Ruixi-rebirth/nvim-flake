{ pkgs, ... }:
{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "auto";
        globalstatus = true;
      };
      sections = {
        lualine_x = [
          {
            __unkeyed-1 = "get_fcitx5_status()";
            color = { fg = "#7aa2f7"; };
          }
          "encoding"
          "fileformat"
          "filetype"
        ];
      };
    };
  };
}
