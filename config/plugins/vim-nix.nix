{ ... }:
{
  plugins.nix = {
    enable = true;

    lazyLoad.settings = {
      ft = [ "nix" ];
    };
  };
}
