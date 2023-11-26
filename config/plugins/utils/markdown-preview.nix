{
  plugins.markdown-preview = {
    enable = true;
    theme = "dark";
  };
  keymaps = [
    {
      mode = "n";
      key = "mp";
      action = "<cmd>MarkdownPreview<cr>";
      options = {
        silent = true;
        desc = "toggle markdown-preview";
      };
    }
  ];
}
