{ ... }:
{
  plugins.treesitter-textobjects = {
    enable = true;
    lazyLoad.settings = {
      keys = [
        # --- Selection (Select) ---
        # Function
        {
          __unkeyed-1 = "if";
          __unkeyed-2 = "<cmd>lua require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')<CR>";
          mode = [
            "x"
            "o"
          ];
          desc = "Inner function";
        }
        {
          __unkeyed-1 = "af";
          __unkeyed-2 = "<cmd>lua require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')<CR>";
          mode = [
            "x"
            "o"
          ];
          desc = "Around function";
        }
        # Class
        {
          __unkeyed-1 = "ic";
          __unkeyed-2 = "<cmd>lua require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')<CR>";
          mode = [
            "x"
            "o"
          ];
          desc = "Inner class";
        }
        {
          __unkeyed-1 = "ac";
          __unkeyed-2 = "<cmd>lua require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')<CR>";
          mode = [
            "x"
            "o"
          ];
          desc = "Around class";
        }
        # Conditional
        {
          __unkeyed-1 = "ii";
          __unkeyed-2 = "<cmd>lua require('nvim-treesitter-textobjects.select').select_textobject('@conditional.inner', 'textobjects')<CR>";
          mode = [
            "x"
            "o"
          ];
          desc = "Inner conditional";
        }
        {
          __unkeyed-1 = "ai";
          __unkeyed-2 = "<cmd>lua require('nvim-treesitter-textobjects.select').select_textobject('@conditional.outer', 'textobjects')<CR>";
          mode = [
            "x"
            "o"
          ];
          desc = "Around conditional";
        }

        # --- Navigation (Move) ---
        {
          __unkeyed-1 = "]m";
          __unkeyed-2 = "<cmd>lua require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer')<CR>";
          desc = "Next function start";
        }
        {
          __unkeyed-1 = "[m";
          __unkeyed-2 = "<cmd>lua require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer')<CR>";
          desc = "Prev function start";
        }
        {
          __unkeyed-1 = "]]";
          __unkeyed-2 = "<cmd>lua require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer')<CR>";
          desc = "Next class start";
        }
        {
          __unkeyed-1 = "[[";
          __unkeyed-2 = "<cmd>lua require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer')<CR>";
          desc = "Prev class start";
        }
      ];
    };
  };
}
