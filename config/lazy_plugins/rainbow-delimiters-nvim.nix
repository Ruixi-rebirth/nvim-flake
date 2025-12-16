{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.rainbow-delimiters-nvim;
  lazy = true;
  event = "BufRead";
  config = ''
    function()
      require('rainbow-delimiters.setup').setup({})
    end
  '';
}
