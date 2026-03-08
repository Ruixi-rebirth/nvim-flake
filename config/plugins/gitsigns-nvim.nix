{ ... }:
{
  plugins.gitsigns = {
    enable = true;
    settings = { };

    lazyLoad.settings = {
      event = [
        "BufRead"
      ];
    };
  };
}
