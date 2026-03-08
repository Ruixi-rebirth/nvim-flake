{ ... }:
{
  plugins.bufferline = {
    enable = true;
    lazyLoad.settings = {
      lazy = false;
      after.__raw = ''
        function()
          local highlights = require("nord").bufferline.highlights({
            italic = true,
            bold = true,
          })
          require("bufferline").setup({
            options = {
              offsets = {
                {
                  filetype = "NvimTree",
                  text = "File Explorer",
                  text_align = "left",
                },
              },
            },
            highlights = highlights,
          })
        end
      '';
    };
  };
}
