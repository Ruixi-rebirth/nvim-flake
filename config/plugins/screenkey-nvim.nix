{ pkgs, inputs, ... }:
let
  screenkey-pkg = pkgs.vimUtils.buildVimPlugin {
    name = "screenkey-nvim";
    src = inputs.screenkey-nvim;
  };
in
{
  extraPlugins = [ screenkey-pkg ];
  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = screenkey-pkg.name;
      lazy = true;
      cmd = [ "Screenkey" ];
      after.__raw = ''
        function()
          require("screenkey").setup({})
        end
      '';
    }
  ];
}
