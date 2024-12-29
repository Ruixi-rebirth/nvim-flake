{ ... }:
{
  plugins = {
    bufferline = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          after = ''
            function()
              local theme_configs = {
                nord = function()
                  return require("nord").bufferline.highlights({
                    italic = true,
                    bold = true,
                  })
                end,
              }

              local current_theme = vim.g.colors_name

              local highlights = nil
              if theme_configs[current_theme] then
                highlights = theme_configs[current_theme]()
              end

              require("bufferline").setup({
                highlights = highlights,
              })
            end
          '';
        };
      };
    };
    web-devicons = {
      enable = true;
    };
  };
}
