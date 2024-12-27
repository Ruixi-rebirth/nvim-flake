{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.neogit;
  lazy = false;
  dependencies = with pkgs.vimPlugins; [
    plenary-nvim
    diffview-nvim
    telescope-nvim
    fzf-lua
  ];
  config = ''
    function()
      local neogit = require('neogit')
      neogit.setup {}
    end
  '';
}
