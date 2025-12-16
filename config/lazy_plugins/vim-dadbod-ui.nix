{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.vim-dadbod-ui;
  lazy = true;
  event = "BufRead";
  dependencies = with pkgs.vimPlugins; [
    vim-dadbod
    {
      pkg = pkgs.vimPlugins.vim-dadbod-completion;
      lazy = true;
      ft = [
        "sql"
        "mysql"
        "plsql"
      ];
    }
  ];
  cmd = [
    "DBUI"
    "DBUIToggle"
    "DBUIAddConnection"
    "DBUIFindBuffer"
  ];
  init = ''
    function()
       vim.g.db_ui_use_nerd_fonts = 1
    end
  '';
}
