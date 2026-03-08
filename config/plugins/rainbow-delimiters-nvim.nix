{ ... }:
{
  plugins.rainbow-delimiters = {
    enable = true;
    settings = { };

    lazyLoad.settings = {
      event = [
        "BufRead"
        "BufNewFile"
      ];
    };
  };
}
