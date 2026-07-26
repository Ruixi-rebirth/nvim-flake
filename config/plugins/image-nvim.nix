{ ... }:
{
  plugins.image = {
    enable = true;

    lazyLoad.settings = {
      event = [ "DeferredUIEnter" ];
    };
  };
}
