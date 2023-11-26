{
  plugins.trouble = {
    enable = true;
  };
  keymaps = [
    {
      mode = "n";
      key = "tr";
      action = "<cmd>TroubleToggle<cr>";
      options = {
        silent = true;
        desc = "togglr trouble";
      };
    }
  ];
}
