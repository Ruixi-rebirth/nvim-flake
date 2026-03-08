{ ... }:
{
  plugins.markdown-preview = {
    enable = true;

    lazyLoad.settings = {
      ft = [ "markdown" ];
      keys = [
        {
          __unkeyed-1 = "mp";
          __unkeyed-2 = "<cmd>MarkdownPreview<cr>";
          desc = "Toggle markdown-preview";
        }
      ];
      before.__raw = ''
        function()
          vim.g.mkdp_filetypes = { "markdown" }
        end
      '';
    };
  };
}
