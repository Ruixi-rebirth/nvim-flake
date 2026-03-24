{ ... }:
{
  extraConfigLua = ''
    -- Fcitx5 status auto-switch
    local function setup_fcitx5()
      if vim.fn.executable("fcitx5-remote") ~= 1 then
        if #vim.api.nvim_list_uis() > 0 then
          vim.notify("fcitx5-remote not found, fcitx5 auto-switch disabled", vim.log.levels.WARN)
        end
        return
      end

      local fcitx5_state = 1
      local fcitx_group = vim.api.nvim_create_augroup("Fcitx5AutoSwitch", { clear = true })

      local function fcitx2en()
        local handle = io.popen("fcitx5-remote")
        if handle then
          local result = handle:read("*all")
          handle:close()
          local status = tonumber(result)
          if status == 2 then
            fcitx5_state = 2
            os.execute("fcitx5-remote -c")
          else
            fcitx5_state = 1
          end
        end
      end

      local function fcitx2zh()
        if fcitx5_state == 2 then
          os.execute("fcitx5-remote -o")
        end
      end

      -- Global function for statusline use
      _G.get_fcitx5_status = function()
        if vim.fn.executable("fcitx5-remote") ~= 1 then return "" end
        local handle = io.popen("fcitx5-remote")
        if handle then
          local result = handle:read("*all")
          handle:close()
          local status = tonumber(result)
          if status == 2 then
            return "󰗊 ZH"
          else
            return "󰗊 EN"
          end
        end
        return ""
      end

      vim.api.nvim_create_autocmd("InsertLeave", {
        group = fcitx_group,
        callback = fcitx2en,
      })

      vim.api.nvim_create_autocmd("InsertEnter", {
        group = fcitx_group,
        callback = fcitx2zh,
      })

      -- Initial switch to English
      fcitx2en()
    end

    -- Schedule execution to avoid blocking or showing notifications too early during startup
    vim.schedule(setup_fcitx5)
  '';
}
