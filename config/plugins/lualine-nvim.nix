{ pkgs, ... }:
{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "auto";
        globalstatus = true;
      };
      sections = {
        lualine_c = [
          {
            __unkeyed-1 = {
              __raw = ''
                function()
                  local ok, gb = pcall(require, 'gitblame')
                    if ok and gb.is_blame_text_available() then
                      return gb.get_current_blame_text()
                    end
                  return ""
                end
              '';
            };
            fmt.__raw = ''
              function(str)
                if str == "" then return str end
                local limit = math.floor(vim.o.columns / 3)
                if #str > limit and limit > 3 then
                  return string.sub(str, 1, limit - 3) .. "..."
                end
                return str
              end
            '';
          }
        ];
        lualine_x = [
          {
            __unkeyed-1 = "get_fcitx5_status()";
            color = {
              fg = "#7aa2f7";
            };
          }
          "encoding"
          "fileformat"
          "filetype"
        ];
      };
    };
    luaConfig.pre = ''
      vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
    '';
  };
}
