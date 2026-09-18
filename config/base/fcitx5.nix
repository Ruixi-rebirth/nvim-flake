{ ... }:
{
  extraConfigLua = ''
    local fcitx_status = ""
    _G.get_fcitx5_status = function() return fcitx_status end

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
      -- Serialize the whole query/switch operation, so a late close cannot
      -- overtake a subsequent InsertEnter restore.
      local queue, running = {}, false
      local function drain()
        if running or #queue == 0 then return end
        running = true
        table.remove(queue, 1)(function()
          running = false
          drain()
        end)
      end
      local function enqueue(operation)
        table.insert(queue, operation)
        drain()
      end
      local function remote(args, callback)
        local ok = pcall(vim.system, args, { text = true, timeout = 1000 },
          vim.schedule_wrap(callback))
        if not ok then callback({ code = -1 }) end
      end
      local function switch(flag, status, done)
        remote({ "fcitx5-remote", flag }, function(result)
          if result.code == 0 then fcitx_status = status end
          done()
        end)
      end

      local function fcitx2en()
        enqueue(function(done)
          remote({ "fcitx5-remote" }, function(result)
            if result.code ~= 0 then done(); return end
            fcitx5_state = tonumber(result.stdout) or 1
            if fcitx5_state == 2 then
              switch("-c", "󰗊 EN", done)
            else
              fcitx_status = "󰗊 EN"
              done()
            end
          end)
        end)
      end

      local function fcitx2zh()
        enqueue(function(done)
          if fcitx5_state == 2 then
            switch("-o", "󰗊 ZH", done)
          else
            done()
          end
        end)
      end

      -- Refresh outside statusline rendering, including manual IM switches.
      local refreshing = false
      vim.api.nvim_create_autocmd({ "CursorHoldI", "FocusGained" }, {
        group = fcitx_group,
        callback = function()
          if refreshing then return end
          refreshing = true
          enqueue(function(done)
            remote({ "fcitx5-remote" }, function(result)
              refreshing = false
              if result.code == 0 then
                fcitx_status = tonumber(result.stdout) == 2 and "󰗊 ZH" or "󰗊 EN"
              end
              done()
            end)
          end)
        end,
      })

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
