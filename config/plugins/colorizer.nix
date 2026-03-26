{ ... }:
{
  plugins.colorizer = {
    enable = true;
    settings = {
      user_default_options = {
        names = false;
        RGB = true;
        AARRGGBB = true;
        RRGGBB = true;
        RRGGBBAA = true;
        mode = "background";
      };
    };
  };
}
