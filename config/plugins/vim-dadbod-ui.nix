{ ... }:
{
  plugins.vim-dadbod-ui = {
    enable = true;

    lazyLoad.settings = {
      cmd = [
        "DBUI"
        "DBUIToggle"
        "DBUIAddConnection"
        "DBUIFindBuffer"
      ];
      event = [ "BufRead" ];
      before.__raw = ''
        function()
           vim.g.db_ui_use_nerd_fonts = 1
        end
      '';
    };
  };

  plugins.vim-dadbod = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings = {
        ft = [
          "sql"
          "mysql"
          "plsql"
        ];
      };
    };
  };

  plugins.vim-dadbod-completion = {
    enable = true;
    lazyLoad = {
      settings = {
        ft = [
          "sql"
          "mysql"
          "plsql"
        ];
      };
    };
  };
}
