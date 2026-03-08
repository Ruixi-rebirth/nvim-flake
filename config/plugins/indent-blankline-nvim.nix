{ ... }:
{
  plugins.indent-blankline = {
    enable = true;

    lazyLoad.settings = {
      event = [
        "BufRead"
        "BufNewFile"
      ];

      after.__raw = ''
        function()
          vim.opt.list = true
          vim.opt.listchars = {
            tab = "▸ ",
            eol = "↩",
          }

          local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
          }
          local hooks = require("ibl.hooks")

          -- Manual highlight creation
          vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
          vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
          vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
          vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
          vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
          vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
          vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })

          vim.g.rainbow_delimiters = { highlight = highlight }

          require("ibl").setup({
            scope = {
              enabled = true,
              highlight = highlight,
            },
          })

          hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end
      '';
    };
  };
}
