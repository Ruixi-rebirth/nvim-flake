{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  nui-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "nui-nvim";
    src = inputs.nui-nvim;
  };
in
{
  pkg = pkgs.vimPlugins.avante-nvim;
  event = "VeryLazy";
  lazy = true;
  keys = lib.nixvim.mkRaw ''
    {
      { "<leader>at", "<cmd>AvanteToggle<CR>", desc = "Toggle Avante" },
      {
          "<leader>a+",
          function()
              local tree_ext = require("avante.extensions.nvim_tree")
              tree_ext.add_file()
          end,
          desc = "Select file in NvimTree",
          ft = "NvimTree",
      },
      {
          "<leader>a-",
          function()
              local tree_ext = require("avante.extensions.nvim_tree")
              tree_ext.remove_file()
          end,
          desc = "Deselect file in NvimTree",
          ft = "NvimTree",
      },
    }
  '';
  dependencies = [
    nui-nvim
  ]
  ++ (with pkgs.vimPlugins; [
    nvim-treesitter
    dressing-nvim
    plenary-nvim
    nvim-web-devicons
    {
      # support for image pasting
      pkg = pkgs.vimPlugins.img-clip-nvim;
      event = "VeryLazy";
      opts = {
        # recommended settings
        default = {
          embed_image_as_base64 = false;
          prompt_for_file_name = false;
          drag_and_drop = {
            insert_mode = true;
          };
          # required for Windows users
          use_absolute_path = true;
        };
      };
    }
    {
      # Make sure to set this up properly if you have lazy=true
      pkg = pkgs.vimPlugins.render-markdown-nvim;
      opts = {
        file_types = [
          "markdown"
          "Avante"
        ];
      };
      ft = [
        "markdown"
        "Avante"
      ];
    }
  ]);
  opts = {
    instructions_file = "avante.md";
    provider = "claude";
    providers = {
      claude = {
        endpoint = "https://api.anthropic.com";
        model = "claude-sonnet-4-20250514";
        extra_request_body = {
          temperature = 0.75;
          max_tokens = 20480;
        };
      };
    };
    dual_boost = {
      enabled = false;
      first_provider = "claude";
      second_provider = "openai";
      prompt = ''
        Based on the two reference outputs below, generate a response that incorporates
        elements from both but reflects your own judgment and unique perspective.
        Do not provide any explanation, just give the response directly.
        Reference Output 1: [{{provider1_output}}],
        Reference Output 2: [{{provider2_output}}]
      '';
      timeout = 60000; # Timeout in milliseconds
    };
    behaviour = {
      auto_suggestions = false; # Experimental stage
      auto_set_highlight_group = true;
      auto_set_keymaps = true;
      auto_apply_diff_after_generation = false;
      support_paste_from_clipboard = false;
    };
    mappings = {
      diff = {
        ours = "co";
        theirs = "ct";
        all_theirs = "ca";
        both = "cb";
        cursor = "cc";
        next = "]x";
        prev = "[x";
      };
      suggestion = {
        accept = "<M-l>";
        next = "<M->>";
        prev = "<M-[>";
        dismiss = "<C->>";
      };
      jump = {
        next = "]]";
        prev = "[[";
      };
      submit = {
        normal = "<CR>";
        insert = "<C-s>";
      };
      sidebar = {
        apply_all = "A";
        apply_cursor = "a";
        switch_windows = "<Tab>";
        reverse_switch_windows = "<S-Tab>";
      };
    };
    windows = {
      position = "right"; # The position of the sidebar
      wrap = true; # Similar to vim.o.wrap
      width = 30; # Default % based on available width
      sidebar_header = {
        enabled = true; # Enable/disable the header
        align = "center"; # Alignment for title
        rounded = true;
      };
      input = {
        prefix = "> ";
        height = 8; # Height of the input window in vertical layout
      };
      edit = {
        border = "rounded";
        start_insert = true; # Start insert mode when opening the edit window
      };
      ask = {
        floating = false; # Open the 'AvanteAsk' prompt in a floating window
        start_insert = true; # Start insert mode when opening the ask window
        border = "rounded";
        focus_on_apply = "ours"; # Which diff to focus after applying
      };
    };
    highlights = {
      diff = {
        current = "DiffText";
        incoming = "DiffAdd";
      };
    };
    diff = {
      autojump = true;
      list_opener = "copen";
      override_timeoutlen = 500; # Timeout override while hovering over a diff
    };
    selector = {
      exclude_auto_select = [ "NvimTree" ];
    };
  };
  config = ''
    function()
      local util = require("lspconfig.util")
      local find_repo_root = function(startpath)
        local repo = vim.fs.find('.repo', { path = startpath, upward = true })[1]
        return repo and vim.fs.dirname(repo) or nil
      end
      local filepath = vim.fn.expand("%:p")
      local root_dir = find_repo_root(filepath) or util.find_git_ancestor(filepath)
      if not root_dir then
        print("No .repo or Git root directory found!")
        return
      end
      local avante_config_path = root_dir .. "/.avante.lua"

      vim.api.nvim_create_user_command("GenerateAvanteConfig", function()
        local config_content = [[
    require("avante").setup({
      provider = "claude",
      providers = {
        openai = {
          endpoint = "https://api.deepseek.com/v1",
          model = "deepseek-chat",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0,
            max_tokens = 18192,
          },
        },
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "gpt-4o-2024-11-20",
          proxy = nil, -- [protocol://]host[:port] Use this proxy
          allow_insecure = false, -- Allow insecure server connections
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0,
            max_tokens = 40960,
          },
        },
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0,
            max_tokens = 64000,
          },
        },
        gemini = {
          endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
          model = "gemini-2.0-flash",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            generationConfig = {
              temperature = 0.75,
            },
          },
        },
      },
      dual_boost = {
        enabled = false,
        first_provider = "claude",
        second_provider = "openai",
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

        local file = io.open(avante_config_path, "w")
        if file then
          file:write(config_content)
          file:close()
          print(".avante.lua configuration file updated at: " .. avante_config_path)
        else
          print("Failed to update .avante.lua configuration file!")
        end

        vim.cmd("source " .. avante_config_path)
      end, {})
      if vim.fn.filereadable(avante_config_path) == 1 then
        dofile(avante_config_path)
      end

      vim.api.nvim_create_user_command("AvanteZenMode", function()
        vim.defer_fn(function()
            require("avante.api").zen_mode()
        end, 100)
      end, {})
    end
  '';
}
