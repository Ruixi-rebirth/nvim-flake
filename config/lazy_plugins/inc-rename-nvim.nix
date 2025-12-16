{ pkgs, lib, ... }:
{
  pkg = pkgs.vimPlugins.inc-rename-nvim;
  keys = lib.nixvim.mkRaw ''
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
