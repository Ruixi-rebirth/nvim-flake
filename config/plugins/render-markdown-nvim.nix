{ ... }:
{
  plugins.render-markdown = {
    enable = true;

    settings = {
      file_types = [
        "markdown"
        "Avante"
      ];
    };

    lazyLoad.settings = {
      ft = [
        "markdown"
        "Avante"
      ];
    };
  };
}
