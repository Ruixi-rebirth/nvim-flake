{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    nvim-ts-context-commentstring
  ];
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "nvim-ts-context-commentstring";
        lazy = true;
        event = "BufRead";
        after = ''
          function()
            vim.g.skip_ts_context_commentstring_module = true
            require("ts_context_commentstring").setup({
              enable_autocmd = false,
            })
          end
        '';
      }
    ];
  };
}
