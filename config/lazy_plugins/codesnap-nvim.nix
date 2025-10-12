{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.codesnap-nvim;
  opts = {
    save_path = "~/Pictures";
    has_breadcrumbs = true;
    show_workspace = true;
    has_line_number = true;
    bg_padding = 0;
    watermark = "";
    code_font_family = "Maple Mono NF CN";
  };
  keys = helpers.mkRaw ''
    {
      { "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
      { "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
    }
  '';
}
