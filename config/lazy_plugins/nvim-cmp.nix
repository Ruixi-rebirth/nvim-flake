{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.nvim-cmp;
  lazy = false;
  event = "InsertEnter";
  dependencies = with pkgs.vimPlugins; [
    friendly-snippets
    cmp-nvim-lsp
    cmp-buffer
    luasnip
    cmp_luasnip
    cmp-nvim-lua
    # cmp-path
    cmp-async-path
    cmp-cmdline
    {
      pkg = pkgs.vimPlugins.copilot-cmp;
      dependencies = with pkgs.vimPlugins; [
        {
          pkg = pkgs.vimPlugins.copilot-lua;
          cmd = "Copilot";
          event = "InsertEnter";
          config = ''
            function()
              require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
                copilot_node_command = "${pkgs.nodejs-18_x}/bin/node",
              })
            end
          '';
        }
      ];
      config = ''
        function()
          require("copilot_cmp").setup({
            event = { "InsertEnter", "LspAttach" },
            fix_pairs = true,
          })
        end
      '';
    }
    {
      pkg = pkgs.vimPlugins.cmp-spell;
      config = ''
        function()
          vim.cmd('highlight clear SpellBad')
          vim.cmd('highlight clear SpellCap')
          vim.cmd('highlight clear SpellLocal')
          vim.cmd('highlight clear SpellRare')
        end
      '';
    }
    cmp-rg
    cmp-calc
  ];
  config = ''
    function()
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        return
      end
      local snip_status_ok, luasnip = pcall(require, "luasnip")
      if not snip_status_ok then
        return
      end

      require("luasnip/loaders/from_vscode").lazy_load()

      local kind_icons = {
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
        Copilot = "",
      }
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
      -- find more here: https://www.nerdfonts.com/cheat-sheet

      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        preselect = cmp.PreselectMode.None,
        mapping = {
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
              fallback()
            end
          end, { "i", "s", "c" }),
          ["<C-u>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.scroll_docs(-4)
            else
              fallback()
            end
          end, { "i", "s", "c" }),
          ["<C-d>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.scroll_docs(4)
            else
              fallback()
            end
          end, { "i", "s", "c" }),
          ["<C-Space>"] = cmp.mapping(function(fallback)
            if not cmp.visible() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s", "c" }),
          ["<C-e>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.abort()
            else
              fallback()
            end
          end, { "i", "s", "c" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s", "c" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s", "c" }),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
              -- path = "[Path]",
              async_path = "[AsynPath]",
              nvim_lua = "[NVIM_LUA]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              copilot = "[Copilot]",
              spell = "[Spell]",
              rg = "[Rg]",
              calc = "[Calc]",
            })[entry.source.name]
            return vim_item
          end,
        },
        sources = {
          { name = "path" },
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "copilot" },
          { name = "rg" },
          { name = "calc" },
          {
            name = "spell",
            options = {
              keep_all_entries = false,
              enable_in_context = function()
                return true
              end,
              preselect_correct_word = true,
            },
          },
          {
            name = "async_path",
            option = {
              show_hidden_files_by_default = true,
            },
          },
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = false,
          native_menu = false,
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            require("copilot_cmp.comparators").prioritize,
            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
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
    end
  '';
}
