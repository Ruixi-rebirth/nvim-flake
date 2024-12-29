{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    todo-comments-nvim
  ];
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "todo-comments.nvim";
        lazy = true;
        event = [ "BufEnter" ];
        after = ''
          function()
            require("todo-comments").setup({})
          end
        '';
      }
    ];
  };
}
