{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.markdown-preview-nvim;
  lazy = true;
  keys = helpers.mkRaw ''
    {
      { "mp", "<cmd>MarkdownPreview<CR>", desc = "toggle markdown-preview" }
    }
  '';
  init = ''
    function()
      vim.g.mkdp_filetypes = { "markdown" }
    end
  '';
  ft = [ "markdown" ];
}
