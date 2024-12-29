{
  pkgs,
  helpers,
  inputs,
  ...
}:
let
  importPlugin = name: import ./plugins/${name}.nix { inherit inputs pkgs helpers; };
  category = {
    theme = [
      "nord-nvim"
    ];
    filetree = "nvim-tree-lua";
    tabline = "bufferline-nvim";
    keybinding = "which-key-nvim";
    terminal = "toggleterm-nvim";
    ai = [
      "avante-nvim"
    ];
    fuzzy_finder = [
      "telescope-nvim"
    ];
    syntax = [
      "nvim-treesitter"
      "vim-nix"
      "rainbow-delimiters-nvim"
      "nvim-ts-context-commentstring"
    ];
    lsp = [
      "nvim-lspconfig"
      "trouble-nvim"
    ];
    debug = [
      "nvim-dap"
    ];
    utils = [
      "undotree"
      "todo-comments-nvim"
      "outline-nvim"
      "nvim-surround"
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
  ] ++ plugins;
}
