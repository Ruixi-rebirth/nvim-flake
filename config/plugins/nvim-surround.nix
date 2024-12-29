{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    nvim-surround
  ];
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "nvim-surround";
        lazy = true;
        event = "BufReadPost";
        after = ''
          function()
             require("nvim-surround").setup()
          end
        '';
      }
    ];
  };
}
