{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.inc-rename-nvim;
  keys = helpers.mkRaw ''
    {
      { "<leader>n", ":IncRename ", desc = "lsp rename" }
    }
  '';
  config = ''
    function()
      require("inc_rename").setup()
    end
  '';
}
