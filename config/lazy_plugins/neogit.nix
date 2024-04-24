{ pkgs, ... }:
with pkgs.vimPlugins; {
  pkg = neogit;
  lazy = false;
  dependencies = [ plenary-nvim diffview-nvim telescope-nvim fzf-lua ];
  config = ''
    function()
      local neogit = require('neogit')
      neogit.setup {}
    end
  '';
}
