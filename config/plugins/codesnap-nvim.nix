{ ... }:
{
  plugins.codesnap = {
    enable = true;

    settings = {
      save_path = "~/Pictures/";
      has_breadcrumbs = true;
      breadcrumbs_separator = "/";
      show_workspace = true;
      has_line_number = true;
      bg_padding = 0;
      watermark = "";
      code_font_family = "Maple Mono NF CN";
    };

    lazyLoad.settings = {
      lazy = false;
      cmd = [
        "CodeSnap"
        "CodeSnapSave"
        "CodeSnapASCII"
        "CodeSnapHighlight"
      ];
      keys = [
        {
          __unkeyed-1 = "<leader>cc";
          __unkeyed-2 = "<cmd>CodeSnap<cr>";
          mode = [ "x" ];
          desc = "Save selected code snapshot into clipboard";
        }
        {
          __unkeyed-1 = "<leader>cs";
          __unkeyed-2 = "<cmd>CodeSnapSave<cr>";
          mode = [ "x" ];
          desc = "Save selected code snapshot in ~/Pictures";
        }
      ];
    };
  };
}
