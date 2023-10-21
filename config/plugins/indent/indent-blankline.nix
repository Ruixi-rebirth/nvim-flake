{
  config = {
    options = {
      list = true;
    };
    extraConfigLua = ''
      --vim.cmd([[set listchars+=space:⋅]])
      vim.cmd([[set listchars+=eol:↴]])

      vim.cmd [[
      set list
      set listchars=tab:▸\ 
      ]]
    '';
    plugins.indent-blankline = {
      enable = true;
      showEndOfLine = true;
      spaceCharBlankline = " ";
      showCurrentContextStart = true;
      showCurrentContextStartOnCurrentLine = true;
      char = "| ";
    };
  };
}
