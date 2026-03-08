{ ... }:
{
  plugins.which-key = {
    enable = true;
    settings = { };
    luaConfig.pre = ''
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    '';
  };
}
