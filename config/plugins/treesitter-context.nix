{ ... }:
{
  plugins.treesitter-context = {
    enable = true;
    settings = {
      # max_lines = 3;
    };
    lazyLoad.settings = {
      event = [ "BufRead" ];
    };
    luaConfig.post = ''
      vim.cmd([[hi TreesitterContextBottom gui=underline guisp='#B38DAC']])
      vim.cmd([[hi TreesitterContextLineNumberBottom gui=underline guisp='#B38DAC']])
    '';
  };
}
