{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.codesnap-nvim;
  opts = {
    save_path = "~/Pictures";
    has_breadcrumbs = true;
    bg_theme = "bamboo";
  };
  keys = helpers.mkRaw ''
    {
      { "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
      { "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
    }
  '';
}
