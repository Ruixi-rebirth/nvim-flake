{
  imports = [ ./source.nix ];
  config = {
    plugins.nvim-cmp = {
      enable = true;
      autoEnableSources = true;
      experimental = {
        ghost_text = false;
        native_menu = false;
      };
      snippet = {
        expand = "luasnip";
      };
      formatting = {
        fields = [ "kind" "abbr" "menu" ];
        format = ''
          function(entry, vim_item)
              vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
              vim_item.menu = ({
                  path = "[Path]",
                  nvim_lua = "[NVIM_LUA]",
                  nvim_lsp = "[LSP]",
                  luasnip = "[Snippet]",
                  buffer = "[Buffer]",
              })[entry.source.name]
              return vim_item
          end
        '';
      };
      sources = [
        { name = "path"; }
        { name = "nvim_lua"; }
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "buffer"; }
      ];
      window = {
        completion = { };
        documentation = { };
      };

      mapping = {
        "<C-u>" = "cmp.mapping.scroll_docs(-4)"; # Up
        "<C-d>" = "cmp.mapping.scroll_docs(4)"; # Down 
        "<C-Space>" = "cmp.mapping.complete()";
        "<CR>" = "cmp.mapping.confirm({select = true,})";

        "<Tab>" = ''cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
            print("Luasnip can expand or jump!")
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end, { "i", "s" })
    '';
        "<S-Tab>" = ''cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
      end, { "i", "s" })
    '';
      };
    };
    extraConfigLua = ''
                   luasnip = require("luasnip")

                   kind_icons = {
                     Text = "󰊄",
                     Method = "",
                     Function = "󰡱",
                     Constructor = "",
                     Field = "",
                     Variable = "󱀍",
                     Class = "",
                     Interface = "",
                     Module = "󰕳",
                     Property = "",
                     Unit = "",
                     Value = "",
                     Enum = "",
                     Keyword = "",
                     Snippet = "",
                     Color = "",
                     File = "",
                     Reference = "",
                     Folder = "",
                     EnumMember = "",
                     Constant = "",
                     Struct = "",
                     Event = "",
                     Operator = "",
                     TypeParameter = "",
                   }-- find more here: https://www.nerdfonts.com/cheat-sheet

                    local cmp = require'cmp'
      			  cmp.setup({
      				window = {
      				completion = cmp.config.window.bordered(),
      				documentation = cmp.config.window.bordered(),
      				},
      			  })
            	
                    cmp.setup.cmdline(":", {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources({
                        { name = "path" },
                    }, {
                        { name = "cmdline" },
                    }),
                  })
    '';
  };
}
