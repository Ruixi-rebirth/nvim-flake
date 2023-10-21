{
  plugins.trouble = {
    enable = true;
  };
  keymaps = [
    {
      mode = "n";
      key = "tr";
      action = "<cmd>TroubleToggle<cr>";
      options.desc = "togglr trouble";
    }
  ];
}
