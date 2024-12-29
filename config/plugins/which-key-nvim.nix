{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    which-key-nvim
  ];
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "which-key.nvim";
        lazy = false;
        beforeAll = ''
          function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
          end
        '';
        after = ''
          function()
            local wk = require("which-key")
            wk.setup({})
          end
        '';
      }
    ];
  };
}
