{ ... }:
{
  plugins.leetcode = {
    enable = true;

    settings = {
      lang = "golang";

      injector = {
        __raw = ''
          {
            golang = {
              before = { "package main" },
            },
          }
        '';
      };

      cn = {
        enabled = true;
        translator = true;
        translate_problems = true;
      };
      storage = {
        home = "~/Codelearning/leetcode";
        cache = "~/Codelearning/leetcode/cache";
      };
      picker.provider = "telescope";
      image_support = true;

      theme = {
        __raw = ''
          (function()
            local colors = require("nord.colors")
            return {
              case_ok = {
                fg = colors.nord14_gui,
                bg = colors.nord0_gui,
                bold = true,
              },
              case_err = {
                fg = colors.nord11_gui,
                bg = colors.nord0_gui,
                bold = true,
              },
              case_focus_ok = {
                fg = colors.nord14_gui,
                bg = colors.nord2_gui,
                bold = true,
              },
              case_focus_err = {
                fg = colors.nord11_gui,
                bg = colors.nord2_gui,
                bold = true,
              },
            }
          end)()
        '';
      };

      console = {
        open_on_runcode = true;
        dir = "row";
        size = {
          width = "90%";
          height = 12;
        };
        result = {
          size = "50%";
        };
        testcase = {
          size = "50%";
        };
      };

      # leetcode.nvim only provides a floating console. Reuse its buffers and
      # result renderer in a persistent, decoration-free bottom split.
      hooks.question_enter = [
        {
          __raw = ''
            function(question)
              local console = question.console
              local original_unmount = console.unmount

              local split_group = vim.api.nvim_create_augroup(
                "LeetConsoleSplits_" .. console.testcase.bufnr, { clear = true }
              )

              local function close_splits(self)
                if self._closing_splits then
                  return
                end
                self._closing_splits = true
                vim.api.nvim_clear_autocmds({ group = split_group })

                local current_win = vim.api.nvim_get_current_win()
                local restore_focus = false
                for _, popup in ipairs(self.popups) do
                  if popup.winid == current_win then
                    restore_focus = true
                    break
                  end
                end

                for _, popup in ipairs(self.popups) do
                  local win = popup.winid
                  popup.winid = nil
                  popup.renderer.winid = nil
                  popup.visible = false
                  if win and vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, true)
                  end
                end
                self.visible = false
                self._closing_splits = false

                local return_win = self._split_return_win
                if restore_focus
                  and return_win
                  and vim.api.nvim_win_is_valid(return_win)
                then
                  vim.api.nvim_set_current_win(return_win)
                end
              end

              local function open_splits(self)
                if self.visible then
                  return
                end

                self._split_return_win = vim.api.nvim_get_current_win()

                -- Constructors already allocate the plugin buffers. Initialize
                -- them directly: mounting then hiding a float re-enters NUI's
                -- window callbacks while converting it into a split.
                if not self._split_initialized then
                  for _, component in ipairs({ self, self.testcase, self.result }) do
                    for _, group in pairs(component._.augroup) do
                      pcall(vim.api.nvim_del_augroup_by_name, group)
                    end
                  end
                  for _, popup in ipairs(self.popups) do
                    for option, value in pairs(popup._.buf_options) do
                      vim.bo[popup.bufnr][option] = value
                    end
                    popup._.mounted = true
                    popup:update_renderer()
                  end
                  self.testcase:autocmds()
                  local keys = require("leetcode.config").user.keys
                  self:set_keymaps({
                    [keys.toggle] = function() self:hide() end,
                    [keys.reset_testcases] = function() self.testcase:reset() end,
                    [keys.use_testcase] = function() self:use_testcase() end,
                    [keys.focus_testcases] = function() self.testcase:focus() end,
                    [keys.focus_result] = function() self.result:focus() end,
                  })
                  self._split_initialized = true
                end

                local source_win = question.winid
                if source_win and vim.api.nvim_win_is_valid(source_win) then
                  vim.api.nvim_set_current_win(source_win)
                end

                vim.cmd("botright 12split")
                local testcase_win = vim.api.nvim_get_current_win()
                vim.api.nvim_win_set_buf(testcase_win, self.testcase.bufnr)

                vim.cmd("rightbelow vsplit")
                local result_win = vim.api.nvim_get_current_win()
                vim.api.nvim_win_set_buf(result_win, self.result.bufnr)

                local total_width = vim.api.nvim_win_get_width(testcase_win)
                  + vim.api.nvim_win_get_width(result_win)
                vim.api.nvim_win_set_width(
                  testcase_win,
                  math.max(20, math.floor(total_width * 0.5))
                )

                self.testcase.winid = testcase_win
                self.testcase.renderer.winid = testcase_win
                self.testcase.visible = true
                self.result.winid = result_win
                self.result.renderer.winid = result_win
                self.result.visible = true
                self.visible = true

                for _, win in ipairs({ testcase_win, result_win }) do
                  vim.api.nvim_create_autocmd("WinClosed", {
                    group = split_group,
                    pattern = tostring(win),
                    callback = function()
                      -- Closing one panel closes the pair, outside WinClosed.
                      vim.schedule(function()
                        if self.visible then self:hide() end
                      end)
                    end,
                  })
                  vim.wo[win].winfixwidth = false
                  vim.wo[win].winfixheight = false
                  vim.wo[win].winhighlight = "Normal:NormalSB"
                  vim.wo[win].wrap = true
                  vim.wo[win].linebreak = true
                  vim.wo[win].number = false
                  vim.wo[win].relativenumber = false
                  vim.wo[win].signcolumn = "no"
                  vim.wo[win].foldcolumn = "0"
                  vim.wo[win].statuscolumn = ""
                  vim.wo[win].winbar = ""
                  vim.wo[win].cursorline = false
                  vim.wo[win].cursorcolumn = false
                  vim.wo[win].list = false
                  vim.wo[win].colorcolumn = ""
                  vim.wo[win].fillchars = "eob: "
                end
              end

              console.mount = open_splits
              console.show = open_splits
              console.hide = close_splits
              console.toggle = function(self)
                if self.visible then
                  close_splits(self)
                else
                  open_splits(self)
                end
              end
              console.unmount = function(self)
                close_splits(self)
                for _, popup in ipairs(self.popups) do
                  popup._.mounted = true
                  popup:unmount()
                end
                self._split_initialized = false
                original_unmount(self)
              end
            end
          '';
        }
      ];
    };

    lazyLoad.settings = {
      cmd = [ "Leet" ];
      before.__raw = ''
        function()
          local lzn = require('lz.n')
          lzn.trigger_load({ 'telescope.nvim', 'image.nvim' })
          local home = vim.fn.expand("~/Codelearning/leetcode")
          vim.fn.mkdir(home, "p")
          if vim.fn.filereadable(home .. "/go.mod") == 0 then
            vim.fn.system({ "go", "-C", home, "mod", "init", "leetcode" })
          end
        end
      '';
      keys = [
        {
          __unkeyed-1 = "<leader>ll";
          __unkeyed-2 = "<cmd>Leet<cr>";
          desc = "LeetCode";
        }
        {
          __unkeyed-1 = "<leader>lr";
          __unkeyed-2 = "<cmd>Leet run<cr>";
          desc = "LeetCode Run";
        }
      ];
    };
  };
}
