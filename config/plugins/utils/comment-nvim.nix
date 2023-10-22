{
  plugins.comment-nvim = {
    enable = true;
    padding = true;
    sticky = true;
    toggler = {
      line = "gcc";
      block = "gbc";
    };
    opleader = {
      line = "gc";
      block = "gb";
    };
    mappings = {
      extra = true;
      basic = true;
      extended = false;
    };
  };
}
