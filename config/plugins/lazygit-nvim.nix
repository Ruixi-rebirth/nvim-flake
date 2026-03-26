{ ... }:
{
  plugins.lazygit = {
    enable = true;

    lazyLoad.settings = {
      cmd = "LazyGit";
      keys = [
        {
          __unkeyed-1 = "<leader>*";
          __unkeyed-2 = "<cmd>LazyGit<cr>";
          desc = "LazyGit";
        }
      ];
    };
  };
}
