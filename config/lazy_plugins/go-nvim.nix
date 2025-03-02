{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.go-nvim;
  lazy = true;
  dependencies = with pkgs.vimPlugins; [
    nvim-lspconfig
    nvim-treesitter
  ];
  event = [ "CmdlineEnter" ];
  ft = [
    "go"
    "gomod"
  ];
  config = ''
    function()
      require("go").setup({
        diagnostic = {
          virtual_text = false,
        },
        lsp_inlay_hints = {
          enable = false,
        },
      })
    end
  '';
}
