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
      options.desc = "toggle markdown-preview";
    }
  ];
}
