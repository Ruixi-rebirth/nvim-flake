{
  plugins.telescope = {
    enable = true;
    keymapsSilent = true;
    keymaps = { };
  };
  keymaps = [
    {
      key = "<Leader>e";
      action = "<cmd>Telescope<CR>";
      options = {
        silent = true;
        desc = "toggle telescope";
      };
    }
  ];
}
