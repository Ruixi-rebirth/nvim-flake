{ pkgs, lib, ... }:
{
  pkg = pkgs.vimPlugins.flash-nvim;
  lazy = true;
  event = "VeryLazy";
  keys = lib.nixvim.mkRaw ''
    {
      {
        "<c-f>",
        mode = { "n", "x", "o" },
        function()
            require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "<Leader>t",
        mode = { "n", "o", "x" },
        function()
            require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "<Leader>r",
        mode = "o",
        function()
            require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "<Leader>T",
        mode = { "o", "x" },
        function()
            require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      }
    }
  '';
  config = ''
    function()
      require("flash").setup({
        labels = "asdfghjklqwertyuiopzxcvbnm",
        search = {
          mode = "fuzzy",
        },
        jump = {
          autojump = false,
        },
        label = {
          rainbow = {
            enabled = false,
            shade = 5,
          },
        },
        prompt = {
          enabled = true,
          prefix = { { "🔎", "FlashPromptIcon" } },
        },
      })
    end
  '';
}
