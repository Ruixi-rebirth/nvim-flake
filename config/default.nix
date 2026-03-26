{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  importPlugin = name: import ./plugins/${name}.nix { inherit inputs pkgs lib; };
  category = {
    theme = [
      "nord-nvim"
    ];
    filetree = [
      "nvim-tree-lua"
    ];
    terminal = [
      "toggleterm-nvim"
    ];
    treesitter = [
      "nvim-treesitter"
      "treesitter-context"
      "treesitter-textobjects"
    ];
    utils = [
      "noice-nvim"
      "comment-nvim"
      "web-devicons"
      "vim-dadbod-ui"
      "nvim-autopairs"
      "nvim-surround"
      "todo-comments-nvim"
      "undotree"
      "aerial"
      "screenkey-nvim"
      "vim-translator"
      "markdown-preview-nvim"
      "codesnap-nvim"
    ];
    git = [
      "gitsigns-nvim"
      "diffview-nvim"
      "lazygit-nvim"
      "git-blame"
    ];
    fuzzy_finder = [
      "telescope-nvim"
    ];
    lsp = [
      "trouble-nvim"
      "nvim-lspconfig"
      "none-ls-nvim"
    ];
    completion = [
      "blink-cmp"
    ];
    statusline = [
      "lualine-nvim"
    ];
    motion = [
      "flash-nvim"
    ];
    tabline = [
      "bufferline-nvim"
    ];
    indent = [
      "indent-blankline-nvim"
    ];
    syntax = [
      "rainbow-delimiters-nvim"
      "render-markdown-nvim"
    ];
    keybinding = [
      "which-key-nvim"
    ];
  };
  plugins = builtins.concatMap (
    cat: map importPlugin (if builtins.isList cat then cat else [ cat ])
  ) (builtins.attrValues category);
in
{
  withNodeJs = true;
  wrapRc = true;
  withPerl = true;
  withRuby = true;
  withPython3 = true;

  plugins.lz-n = {
    enable = true;
    package = pkgs.vimPlugins.lz-n.overrideAttrs (old: {
      src = inputs.lz-n;
    });
    autoLoad = true;
  };

  imports = [
    ./base
  ]
  ++ plugins;
}
