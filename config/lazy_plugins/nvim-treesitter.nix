{ pkgs, ... }:
let
  nvim-plugintree = pkgs.vimPlugins.nvim-treesitter.withPlugins (
    p: with p; [
      bash
      go
      javascript
      json
      lua
      markdown
      markdown_inline
      nix
      python
      rust
      yaml
      toml
      haskell
    ]
  );

  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = nvim-plugintree.dependencies;
  };
in
{
  pkg = pkgs.vimPlugins.nvim-treesitter;
  config = ''
    function()
      vim.opt.runtimepath:append("${nvim-plugintree}")
      vim.opt.runtimepath:append("${treesitter-parsers}")
      require'nvim-treesitter.configs'.setup {
        parser_install_dir = "${treesitter-parsers}",
        ensure_installed = {},
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      }
    end
  '';
  lazy = true;
  event = "BufRead";
  dependencies = with pkgs.vimPlugins; [
    nvim-treesitter-context
    nvim-treesitter-textobjects
  ];
}
