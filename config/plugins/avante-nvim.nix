{ inputs, pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    img-clip-nvim
    nvim-treesitter
    dressing-nvim
    nui-nvim
    render-markdown-nvim
    nvim-web-devicons
    (avante-nvim.overrideAttrs (old: {
      src = inputs.avante-nvim;
    }))
  ];
  plugins = {
    avante = {
      enable = true;
    };
    lz-n.plugins = [
      {
        __unkeyed-1 = "render-markdown";
        lazy = true;
        ft = [
          "markdown"
          "Avante"
        ];
        after = ''
          function()
            require("render-markdown").setup({
              file_types = {
                "markdown",
                "Avante",
              },
            })
          end
        '';
      }
      {
        # support for image pasting
        __unkeyed-1 = "img-clip.nvim";
        lazy = false;
        after = ''
          function()
            require("img-clip").setup({
              -- recommended settings
              default = {
                embed_image_as_base64 = false,
                prompt_for_file_name = false,
                drag_and_drop = {
                  insert_mode = true,
                },
                -- required for Windows users
                use_absolute_path = true,
              };
            })
          end
        '';
      }
      {
        __unkeyed-1 = "avante.nvim";
        lazy = false;
        keys = [
          {
            __unkeyed-1 = "<leader>at";
            __unkeyed-2 = "<cmd>AvanteToggle<CR>";
            desc = "Toggle avante";
          }
        ];
        after = ''
          function()
            require("avante").setup({
              provider = "claude", -- Recommend using Claude. "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot"
              auto_suggestions_provider = "claude", -- Auto-suggestions provider
              claude = {
                endpoint = "https://api.anthropic.com",
                model = "claude-3-5-sonnet-20241022",
                temperature = 0,
                max_tokens = 4096,
              },
              dual_boost = {
                enabled = false,
                first_provider = "openai",
                second_provider = "claude",
                prompt = [[
                  Based on the two reference outputs below, generate a response that incorporates
                  elements from both but reflects your own judgment and unique perspective.
                  Do not provide any explanation, just give the response directly.
                  Reference Output 1: [{{provider1_output}}],
                  Reference Output 2: [{{provider2_output}}]
                ]],
                timeout = 60000, -- Timeout in milliseconds
              },
              behaviour = {
                auto_suggestions = false, -- Experimental stage
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
              },
              mappings = {
                diff = {
                  ours = "co",
                  theirs = "ct",
                  all_theirs = "ca",
                  both = "cb",
                  cursor = "cc",
                  next = "]x",
                  prev = "[x",
                },
                suggestion = {
                  accept = "<M-l>",
                  next = "<M->>",
                  prev = "<M-[>",
                  dismiss = "<C->>",
                },
                jump = {
                  next = "]]",
                  prev = "[[",
                },
                submit = {
                  normal = "<CR>",
                  insert = "<C-s>",
                },
                sidebar = {
                  apply_all = "A",
                  apply_cursor = "a",
                  switch_windows = "<Tab>",
                  reverse_switch_windows = "<S-Tab>",
                },
              },
              windows = {
                position = "right", -- The position of the sidebar
                wrap = true, -- Similar to vim.o.wrap
                width = 30, -- Default % based on available width
                sidebar_header = {
                  enabled = true, -- Enable/disable the header
                  align = "center", -- Alignment for title
                  rounded = true,
                },
                input = {
                  prefix = "> ",
                  height = 8, -- Height of the input window in vertical layout
                },
                edit = {
                  border = "rounded",
                  start_insert = true, -- Start insert mode when opening the edit window
                },
                ask = {
                  floating = false, -- Open the 'AvanteAsk' prompt in a floating window
                  start_insert = true, -- Start insert mode when opening the ask window
                  border = "rounded",
                  focus_on_apply = "ours", -- Which diff to focus after applying
                },
              },
              highlights = {
                diff = {
                  current = "DiffText",
                  incoming = "DiffAdd",
                },
              },
              diff = {
                autojump = true,
                list_opener = "copen",
                override_timeoutlen = 500, -- Timeout override while hovering over a diff
              },
            })
            vim.api.nvim_create_user_command("GenerateAvanteConfig", function()
              local util = require("lspconfig.util")
              local root_dir = util.find_git_ancestor(vim.fn.expand("%:p"))
              if not root_dir then
                print("No Git root directory found!")
                return
              end

              local nvim_config_path = root_dir .. "/.nvim.lua"
              local config_content = [[
                require("avante").setup({
                  provider = "copilot",
                  auto_suggestions_provider = "claude",
                  openai = {
                    endpoint = "https://api.openai.com/v1",
                    model = "gpt-4o",
                    timeout = 30000, -- Timeout in milliseconds
                    temperature = 0,
                    max_tokens = 4096,
                  },
                  copilot = {
                    endpoint = "https://api.githubcopilot.com",
                    model = "gpt-4o-2024-08-06",
                    proxy = nil, -- [protocol://]host[:port] Use this proxy
                    allow_insecure = false, -- Allow insecure server connections
                    timeout = 30000, -- Timeout in milliseconds
                    temperature = 0,
                    max_tokens = 4096,
                  },
                  claude = {
                    endpoint = "https://api.anthropic.com",
                    model = "claude-3-5-sonnet-20241022",
                    timeout = 30000, -- Timeout in milliseconds
                    temperature = 0,
                    max_tokens = 8000,
                  },
                  gemini = {
                    endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
                    model = "gemini-1.5-flash-latest",
                    timeout = 30000, -- Timeout in milliseconds
                    temperature = 0,
                    max_tokens = 4096,
                  },
                  dual_boost = {
                    enabled = false,
                    first_provider = "openai",
                    second_provider = "claude",
                    prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
                    timeout = 60000, -- Timeout in milliseconds
                  },
                  ---Specify the behaviour of avante.nvim
                  ---1. auto_apply_diff_after_generation: Whether to automatically apply diff after LLM response.
                  ---                                     This would simulate similar behaviour to cursor. Default to false.
                  ---2. auto_set_keymaps                : Whether to automatically set the keymap for the current line. Default to true.
                  ---                                     Note that avante will safely set these keymap. See https://github.com/yetone/avante.nvim/wiki#keymaps-and-api-i-guess for more details.
                  ---3. auto_set_highlight_group        : Whether to automatically set the highlight group for the current line. Default to true.
                  ---4. support_paste_from_clipboard    : Whether to support pasting image from clipboard. This will be determined automatically based whether img-clip is available or not.
                  behaviour = {
                    auto_suggestions = false, -- Experimental stage
                    auto_set_highlight_group = true,
                    auto_set_keymaps = true,
                    auto_apply_diff_after_generation = false,
                    support_paste_from_clipboard = false,
                  },
                })]]

              local mode = vim.loop.fs_stat(nvim_config_path) and "a" or "w"
              local file = io.open(nvim_config_path, mode)
              if file then
                file:write(config_content)
                file:close()
                print(".nvim.lua configuration file updated at: " .. nvim_config_path)
              else
                print("Failed to update .nvim.lua configuration file!")
              end

              vim.cmd("source " .. nvim_config_path)
            end, {})
          end
        '';
      }
    ];
  };
}
