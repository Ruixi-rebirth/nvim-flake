{
  pkgs,
  inputs,
  ...
}:
let
  minuet-ai-pkg = pkgs.vimUtils.buildVimPlugin {
    name = "minuet-ai";
    src = inputs.minuet-ai-nvim;
    doCheck = false;
  };
in
{
  plugins.blink-cmp = {
    enable = true;
    package = inputs.blink-cmp.packages.${pkgs.stdenv.hostPlatform.system}.blink-cmp;

    lazyLoad.settings = {
      before.__raw = ''
        function()
          local lzn = require('lz.n')
          lzn.trigger_load({
            'vim-dadbod-completion',
          })
        end
      '';
      event = [ "InsertEnter" ];
    };

    settings = {
      cmdline = {
        enabled = true;
        keymap = null;
        completion = {
          list.selection = {
            preselect = false;
            auto_insert = true;
          };
          menu.auto_show = true;
          ghost_text.enabled = false;
        };
      };
      term = {
        enabled = true;
        keymap = null;
        completion = {
          menu.auto_show = true; # Whether to automatically show the window when new completion items are available
          ghost_text.enabled = false; # Displays a preview of the selected item on the current line
          trigger = {
            show_on_blocked_trigger_characters = [ ];
            show_on_x_blocked_trigger_characters = null; # Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
          };
          list.selection = {
            preselect = null; # When `true`, will automatically select the first item in the completion list
            auto_insert = null; # When `true`, inserts the completion item automatically when selecting it
          };
        };
      };

      completion = {
        accept.auto_brackets.enabled = true;
        list = {
          selection = {
            preselect = false;
            auto_insert = true;
          };
          cycle = {
            # When `true`, calling `select_next` at the *bottom* of the completion list
            # will select the *first* completion item.
            from_bottom = true;
            # When `true`, calling `select_prev` at the *top* of the completion list
            # will select the *last* completion item.
            from_top = true;
          };
        };
        menu = {
          enabled = true;
          border = "rounded";
          winblend = 0;
          auto_show = true;
          winhighlight = "Normal:_BlinkCmpMenu,FloatBorder:_BlinkCmpMenuBorder,CursorLine:_BlinkCmpMenuSelection,Search:None";
          draw = {
            align_to = "label";
            gap = 1;
            padding = 0;
            treesitter = [ "lsp" ];
            columns = [
              { __unkeyed-1 = "kind_icon"; }
              {
                __unkeyed-1 = "label";
                __unkeyed-2 = "label_description";
                gap = 1;
              }
              { __unkeyed-1 = "source_name"; }
            ];
            components = {
              kind_icon = {
                ellipsis = false;
                text.__raw = "function(ctx) return ctx.kind_icon .. ctx.icon_gap end";
                highlight.__raw = "function(ctx) return ctx.kind_hl end";
              };
              kind = {
                ellipsis = false;
                width = {
                  fill = true;
                };
                text.__raw = "function(ctx) return ctx.kind end";
                highlight.__raw = "function(ctx) return ctx.kind_hl end";
              };
              label = {
                width = {
                  fill = true;
                  max = 60;
                };
                text.__raw = "function(ctx) return ctx.label .. ctx.label_detail end";
                highlight.__raw = ''
                  function(ctx)
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
                  end
                '';
              };
              label_description = {
                width = {
                  max = 30;
                };
                text.__raw = "function(ctx) return ctx.label_description end";
                highlight = "BlinkCmpLabelDescription";
              };
              source_name = {
                width = {
                  fill = true;
                  max = 30;
                };
                text.__raw = "function(ctx) return ctx.source_name end";
                highlight = "BlinkCmpSource";
              };
            };
          };
        };
        keyword.range = "full";
        trigger = {
          prefetch_on_insert = false;
          show_on_keyword = true;
          show_in_snippet = true;
          show_on_trigger_character = true;
          show_on_insert_on_trigger_character = true;
          show_on_accept_on_trigger_character = true;
          show_on_blocked_trigger_characters = [
            " "
            "\n"
            "\t"
          ];
          show_on_x_blocked_trigger_characters = [
            "'"
            "\""
            "("
          ];
        };
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 100;
          update_delay_ms = 50;
          treesitter_highlighting = true;
          window = {
            border = "rounded";
            winblend = 0;
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc";
          };
        };
        ghost_text.enabled = false;
      };

      signature = {
        enabled = true;
        window = {
          border = "double";
          winblend = 0;
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder";
          treesitter_highlighting = true;
          show_documentation = true;
        };
        trigger = {
          blocked_trigger_characters = [ ];
          blocked_retrigger_characters = [ ];
          show_on_insert_on_trigger_character = true; # When true, will show the signature help window when the cursor comes after a trigger character when entering insert mode
        };
      };

      keymap = {
        preset = "none";
        "<cr>" = [
          "accept"
          "fallback"
        ];
        "<S-Tab>" = [
          "select_prev"
          "snippet_backward"
          "fallback"
        ];
        "<Tab>" = [
          "select_next"
          "snippet_forward"
          "fallback"
        ];
        "<c-u>" = [
          "scroll_documentation_up"
          "fallback"
        ];
        "<c-d>" = [
          "scroll_documentation_down"
          "fallback"
        ];
        "<c-.>".__raw = ''
          {
            function(cmp)
              if cmp.is_visible() then
                cmp.cancel()
              else
                cmp.show()
              end
            end,
          }
        '';
      };

      sources = {
        default = [
          "lsp"
          "path"
          "snippets"
          "cmdline"
          "buffer"
          "copilot"
          "dadbod"
          "minuet"
          "avante"
        ];
        providers = {
          lsp.score_offset = 5;
          snippets = {
            opts = {
              friendly_snippets = true;
              # see the list of frameworks in: https://github.com/rafamadriz/friendly-snippets/tree/main/snippets/frameworks
              # and search for possible languages in: https://github.com/rafamadriz/friendly-snippets/blob/main/package.json
              # the following is just an example, you should only enable the frameworks that you use
              extended_filetypes = {
                markdown = [ "jekyll" ];
                sh = [ "shelldoc" ];
              };
            };
            score_offset = 4;
          };
          minuet = {
            name = "minuet";
            module = "minuet.blink";
            async = true;
            score_offset = 101; # Gives minuet higher priority among suggestions
            transform_items.__raw = ''
              function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Minuet"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                  item.source_name = "Minuet"
                end
                return items
              end
            '';
          };
          cmdline = {
            enabled.__raw = "function() return vim.api.nvim_get_mode().mode == 'c' and vim.fn.getcmdtype() == ':' end";
            name = "cmdline";
            module = "blink.cmp.sources.cmdline";
            score_offset = 5;
            transform_items.__raw = ''
              function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Cmdline"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                  item.source_name = "Cmdline"
                end
                return items
              end
            '';
          };
          copilot = {
            enabled = true;
            name = "copilot";
            module = "blink-copilot";
            score_offset = 100;
            async = true;
            opts = {
              max_completions = 3;
              max_attempts = 4;
              debounce = 200;
              auto_refresh = {
                backward = true;
                forward = true;
              };
            };
            transform_items.__raw = ''
              function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Copilot"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                  item.source_name = "Copilot"
                end
                return items
              end
            '';
          };
          dadbod = {
            name = "Dadbod";
            module = "vim_dadbod_completion.blink";
            score_offset = -3;
          };
          avante = {
            module = "blink-cmp-avante";
            name = "Avante";
          };
        };
      };

      appearance = {
        nerd_font_variant = "normal";
        kind_icons = {
          Text = "󰊄";
          Method = "";
          Function = "󰡱";
          Constructor = "";
          Field = "";
          Variable = "󱀍";
          Class = "";
          Interface = "";
          Module = "󰕳";
          Property = "";
          Unit = "";
          Value = "";
          Enum = "";
          Keyword = "";
          Snippet = "";
          Color = "";
          File = "";
          Reference = "";
          Folder = "";
          EnumMember = "";
          Constant = "";
          Struct = "";
          Event = "";
          Operator = "";
          TypeParameter = "";
          Cmdline = "";
          Copilot = "";
          Minuet = "󱗻";
        };
      };

      fuzzy = {
        implementation = "prefer_rust_with_warning";
        prebuilt_binaries.download = false;
      };
    };
  };

  plugins.copilot-lua = {
    enable = true;
    lazyLoad.settings = {
      event = [ "InsertEnter" ];
    };
    settings = {
      suggestion = {
        enabled = false;
        auto_trigger = true;
        keymap = {
          accept = "<C-cr>";
        };
      };
      panel.enabled = false;
      copilot_node_command = "${pkgs.nodejs}/bin/node";
      filetypes = {
        "*" = true;
      };
    };
  };

  plugins.minuet = {
    enable = true;
    package = minuet-ai-pkg;
    lazyLoad = {
      enable = true;
      settings = {
        event = [
          "InsertEnter"
        ];
      };
    };
    settings = {
      # you can use deepseek with both openai_fim_compatible or openai_compatible provider
      provider = "openai_fim_compatible";
      provider_options = {
        openai_fim_compatible = {
          api_key = "OPENAI_API_KEY";
          name = "deepseek";
          optional = {
            max_tokens = 4096;
            top_p = 0.9;
          };
        };
        openai_compatible = {
          api_key = "OPENAI_API_KEY";
          end_point = "https://api.deepseek.com/v1/chat/completions";
          name = "deepseek";
          optional = {
            max_tokens = 4096;
            top_p = 0.9;
          };
        };
      };
    };
  };

  plugins.blink-copilot = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings = {
        event = [
          "InsertEnter"
        ];
      };
    };
  };

  plugins.friendly-snippets = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings = {
        event = [
          "InsertEnter"
        ];
      };
    };
  };

  plugins.blink-cmp-avante = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings = {
        event = [
          "InsertEnter"
        ];
      };
    };
  };
}
