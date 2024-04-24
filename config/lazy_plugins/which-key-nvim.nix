{ pkgs, ... }:
with pkgs.vimPlugins; {
  pkg = which-key-nvim;
  lazy = false;
  event = "VeryLazy";
  init = ''
    function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end
  '';
  config = ''
    function()
      local wk = require("which-key")
      wk.setup({})
    end
  '';
}
