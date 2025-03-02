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
})