{
  pkgs,
  inputs,
  helpers,
  ...
}:
{
  pkg = inputs.blink-cmp.packages.${pkgs.system}.default;
  lazy = true;
  event = "InsertEnter";
  dependencies =
    with pkgs.vimPlugins;
    [
      friendly-snippets
      luasnip
      {
        pkg = pkgs.vimPlugins.blink-compat;
        lazy = true;
        opts = { };
      }
    ]
    ++ [
      # nvim-cmp source
      blink-compat
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
      require("blink.cmp").setup({
        completion = {
          accept = {
            auto_brackets = {
              enabled = true,
            },
          },
          list = {
            selection = "auto_insert",
            cycle = {
              -- When `true`, calling `select_next` at the *bottom* of the completion list
              -- will select the *first* completion item.
              from_bottom = true,
              -- When `true`, calling `select_prev` at the *top* of the completion list
              -- will select the *last* completion item.
              from_top = true,
            },
          },
          menu = {
            enabled = true,
            border = "rounded",
            winblend = 0,
            auto_show = true,
            winhighlight = "Normal:_BlinkCmpMenu,FloatBorder:_BlinkCmpMenuBorder,CursorLine:_BlinkCmpMenuSelection,Search:None",
            draw = {
              align_to = 'label',
              gap = 1,
              padding = 0,
              treesitter = { "lsp" },
              columns = {
                { "kind_icon" },
                { "label",      "label_description", gap = 1 },
                { "source_name" },
              },
              components = {
                kind_icon = {
                  ellipsis = false,
                  text = function(ctx)
                    return ctx.kind_icon .. ctx.icon_gap
                  end,
                  highlight = function(ctx)
                    return require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx) or "BlinkCmpKind" .. ctx.kind
                  end,
                },
                kind = {
                  ellipsis = false,
                  width = { fill = true },
                  text = function(ctx)
                    return ctx.kind
                  end,
                  highlight = function(ctx)
                    return require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx) or "BlinkCmpKind" .. ctx.kind
                  end,
                },
                label = {
                  width = { fill = true, max = 60 },
                  text = function(ctx)
                    return ctx.label .. ctx.label_detail
                  end,
                  highlight = function(ctx)
                    -- label and label details
                    local highlights = {
                      { 0, #ctx.label, group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel" },
                    }
                    if ctx.label_detail then
                      table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" })
                    end

                    -- characters matched on the label by the fuzzy matcher
                    for _, idx in ipairs(ctx.label_matched_indices) do
                      table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                    end

                    return highlights
                  end,
                },
                label_description = {
                  width = { max = 30 },
                  text = function(ctx)
                    return ctx.label_description
                  end,
                  highlight = "BlinkCmpLabelDescription",
                },
                source_name = {
                  width = { fill = true, max = 30 },
                  text = function(ctx)
                    return ctx.source_name
                  end,
                  highlight = "BlinkCmpSource",
                },
              },
            },
          },
          keyword = {
            range = full,
          },
          trigger = {
            show_on_keyword = true,
            show_on_trigger_character = true,
            show_on_insert_on_trigger_character = true,
            show_on_accept_on_trigger_character = true,
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 100,
            update_delay_ms = 50,
            treesitter_highlighting = true,
            window = {
              border = "rounded",
              winblend = 0,
              winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
            },
          },
          ghost_text = {
            enabled = false,
          },
        },
        signature = {
          enabled = true,
          window = {
            border = "double",
            winblend = 0,
            winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
            treesitter_highlighting = true,
          },
          trigger = {
            blocked_trigger_characters = {},
            blocked_retrigger_characters = {},
            -- When true, will show the signature help window when the cursor comes after a trigger character when entering insert mode
            show_on_insert_on_trigger_character = true,
          },
        },
        keymap = {
          preset = none,
          ["<cr>"] = { "accept", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
          ["<Tab>"] = { "select_next", "fallback" },
          ["<c-u>"] = { "scroll_documentation_up", "fallback" },
          ["<c-d>"] = { "scroll_documentation_down", "fallback" },
          ["<c-.>"] = {
            function(cmp)
              if cmp.is_visible() then
                cmp.cancel()
              else
                cmp.show()
              end
            end,
          },
        },
        snippets = {
          expand = function(snippet)
            require("luasnip").lsp_expand(snippet)
          end,
          active = function(filter)
            if filter and filter.direction then
              return require("luasnip").jumpable(filter.direction)
            end
            return require("luasnip").in_snippet()
          end,
          jump = function(direction)
            require("luasnip").jump(direction)
          end,
        },
        sources = {
          default = { "lsp", "path", "snippets", "luasnip", "cmdline", "buffer", "copilot", "spell", "calc", "rg", "dadbod" },
          providers = {
            lsp = { score_offset = 5, },
            snippets = { score_offset = 4, },
            cmdline = {
              enabled = function()
                return vim.fn.mode() == "c"
              end,
              name = "cmdline",
              module = "blink.cmp.sources.cmdline",
              score_offset = 5,
              transform_items = function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Cmdline"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                  item.source_name = "Cmdline"
                end
                return items
              end,
            },
            copilot = {
              enabled = true,
              name = "copilot", -- same as source_name in nvim-cmp
              module = "blink.compat.source",
              score_offset = 100,
              async = true,
              transform_items = function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Copilot"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                  item.source_name = "Copilot"
                end
                return items
              end,
            },
            spell = {
              enabled = true,
              name = "spell", -- same as source_name in nvim-cmp
              module = "blink.compat.source",
              async = true,
              score_offset = -5,
              transform_items = function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Spell"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                  item.source_name = "Spell"
                end
                return items
              end,
            },
            calc = {
              enabled = true,
              name = "calc", -- same as source_name in nvim-cmp
              module = "blink.compat.source",
              async = true,
              score_offset = -5,
              transform_items = function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Calc"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                  item.source_name = "Calc"
                end
                return items
              end,
            },
            rg = {
              enabled = true,
              name = "rg", -- same as source_name in nvim-cmp
              module = "blink.compat.source",
              async = true,
              score_offset = -5,
              transform_items = function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Rg"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                  item.source_name = "Rg"
                end
                return items
              end,
            },
            dadbod = {
              name = "Dadbod",
              module = "vim_dadbod_completion.blink",
              score_offset = -3,
            },
          },
        },
        appearance = {
          nerd_font_variant = "normal",
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
            Cmdline = "",
            Copilot = "",
            Spell = "󰓆",
            Calc = "",
            Rg = "",
          },
        },
        fuzzy = {
          prebuilt_binaries = {
            download = false,
          },
        }
      })
    end
  '';
}