{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.todo-comments-nvim;
  lazy = true;
  dependencies = with pkgs.vimPlugins; [ plenary-nvim ];
  event = "InsertEnter";
  config = ''
    function()
      require("todo-comments").setup({})
    end
  '';
}
