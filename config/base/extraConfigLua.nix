{
  extraConfigLua = ''
    --  Add '-' to the list of characters considered part of a keyword
    vim.cmd([[set iskeyword+=-]])
    -- Allow moving between lines using arrow keys and h/l when at the start/end of a line
    vim.cmd("set whichwrap+=<,>,[,],h,l")

    local load_clipboard_config = function()
      if vim.fn.has("wsl") == 1 then
        vim.g.clipboard = {
          name = "WslClipboard",
          copy = {
            ["+"] = "cb cp",
            ["*"] = "cb cp",
          },
          paste = {
            ["+"] = "cb p",
            ["*"] = "cb p",
          },
          cache_enabled = 0,
        }
      end
    end
    load_clipboard_config()
  '';
}
