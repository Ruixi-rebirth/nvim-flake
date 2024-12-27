{
  pkgs,
  helpers,
  inputs,
  ...
}:
let
  importPlugin = name: import ./lazy_plugins/${name}.nix { inherit pkgs helpers inputs; };
  category = {
    theme = [
      "nord-nvim"
      # "nordic-nvim"
    ];
    filetree = "nvim-tree-lua";
    terminal = "toggleterm-nvim";
    tabline = "bufferline-nvim";
    statusline = "lualine-nvim";
    motion = "flash-nvim";
    keybinding = "which-key-nvim";
    indent = "indent-blankline-nvim";
    git = [
      "gitsigns-nvim"
      # "neogit"
      "diffview-nvim"
    ];
    fuzzy_finder = [
      "telescope-nvim"
    ];
    debug = [
      "nvim-dap"
      "nvim-dap-ui"
      "nvim-dap-go"
      "nvim-dap-virtual-text"
    ];
    syntax = [
      "nvim-treesitter"
      "vim-nix"
      "nvim-ts-context-commentstring"
      "rainbow-delimiters-nvim"
    ];
    completion = [
      "blink-cmp"
      # "nvim-cmp"
    ];
    lsp = [
      "nvim-lspconfig"
      # "lspsaga-nvim"
      "trouble-nvim"
      "none-ls-nvim"
      # "LspUI-nvim"
    ];
    ai = [
      "avante-nvim"
    ];
    utils = [
      "undotree"
      "nvim-surround"
      "noice-nvim"
      "nvim-autopairs"
      "todo-comments-nvim"
      "markdown-preview-nvim"
      # "img-clip-nvim"
      # "render-markdown-nvim"
      "comment-nvim"
      "outline-nvim"
      "codesnap-nvim"
      "vim-dadbod-ui"
      "screenkey-nvim"
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

  imports = [
    ./base
  ];
  plugins.lazy = {
    inherit plugins;
    enable = true;
  };
}
