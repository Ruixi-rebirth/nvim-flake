{ pkgs, ... }:
with pkgs.vimPlugins; {
  pkg = todo-comments-nvim;
  lazy = true;
  dependencies = [ plenary-nvim ];
  event = "InsertEnter";
  config = ''
    function()
       require("todo-comments").setup({
       })
    end
  '';
}
