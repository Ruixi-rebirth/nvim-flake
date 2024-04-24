{
  plugins.nvim-tree = {
    enable = true;
    disableNetrw = true;
    hijackCursor = true;
    sortBy = "case_sensitive";
    view = {
      number = false;
      width = 25;
      side = "left";
    };
    renderer = {
      groupEmpty = true;
    };
    filters = {
      dotfiles = true; # Toggle via the toggle_dotfiles action, default mapping `H`
    };
    diagnostics = {
      enable = true;
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "tt";
      action = "<cmd>NvimTreeToggle<cr>";
      options = {
        silent = true;
        desc = "Toggle nvim-tree";
      };
    }
  ];
}
