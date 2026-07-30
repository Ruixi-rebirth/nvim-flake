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
              local original_mount = console.mount
              local original_hide = console.hide
              local original_unmount = console.unmount

              -- The native console hides on BufLeave/WinLeave. A split should
              -- remain visible while moving between the editor and console.
              for _, popup in ipairs(console.popups) do
                popup.handle_leave = function() end
              end

              local function close_splits(self)
                if self._closing_splits then
                  return
                end
                self._closing_splits = true

                local current_win = vim.api.nvim_get_current_win()
                local restore_focus = false
                for _, popup in ipairs(self.popups) do
                  if popup.winid == current_win then
                    restore_focus = true
                    break
                  end
                end

                for _, popup in ipairs(self.popups) do
                  if popup.winid and vim.api.nvim_win_is_valid(popup.winid) then
                    vim.api.nvim_win_close(popup.winid, true)
                  end
                  popup.winid = nil
                  popup.renderer.winid = nil
                  popup.visible = false
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

                -- Initialize the plugin-owned buffers once, then close the
                -- floating layout before placing those buffers in splits.
                if not self._.mounted then
                  original_mount(self)
                  original_hide(self)

                  -- Nui keeps BufWinEnter callbacks in its unmount group,
                  -- while hiding the float removes the hide group those
                  -- callbacks write to. Recreate it before reusing the
                  -- buffers in normal windows.
                  vim.api.nvim_create_augroup(
                    self._.augroup.hide,
                    { clear = true }
                  )
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
            vim.fn.system({ "go", "mod", "init", "-C", home, "leetcode" })
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
