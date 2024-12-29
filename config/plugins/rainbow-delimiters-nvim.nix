{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    rainbow-delimiters-nvim
  ];
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "rainbow-delimiters.nvim";
        lazy = true;
        event = [ "BufRead" ];
        after = ''
          function()
            require('rainbow-delimiters.setup').setup({})
          end
        '';
      }
    ];
  };
}
