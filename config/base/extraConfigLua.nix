{
  extraConfigLua = ''
    --  Add '-' to the list of characters considered part of a keyword
    vim.cmd([[set iskeyword+=-]])
    -- Allow moving between lines using arrow keys and h/l when at the start/end of a line
    vim.cmd("set whichwrap+=<,>,[,],h,l")

    local function load_project_nvim_config()
      local function find_project_root(fname)
        local root = vim.fs.find({ ".repo", ".git" }, {
          path = fname,
          upward = true,
        })[1]
        return root and vim.fs.dirname(root) or nil
      end

      local current_file = vim.fn.expand("%:p")
      if current_file == "" or vim.bo.buftype ~= "" then return end
      local project_root = find_project_root(current_file)

      if project_root then
        local nvim_config_path = project_root .. "/.nvim.lua"
        if vim.loop.fs_stat(nvim_config_path) then
          vim.cmd("source " .. nvim_config_path)
        end
      end
    end

    -- Trigger project-local config loading only when a file is opened
    vim.api.nvim_create_autocmd("BufReadPost", {
      callback = load_project_nvim_config,
      desc = "Load project-local .nvim.lua config"
    })

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
