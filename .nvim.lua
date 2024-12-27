local nvim_lsp = require("lspconfig")
nvim_lsp.nixd.setup({
  cmd = { "nixd" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = 'import (builtins.getFlake ("git+file://" + toString ./.)).inputs.nixpkgs { }',
      },
      formatting = {
        command = { "nix fmt" },
      },
      options = {
        flake_parts = {
          expr =
          'let flake = builtins.getFlake ("git+file://" + toString ./.); in flake.debug.options // flake.currentSystem.options',
        },
        nixvim = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).packages.${builtins.currentSystem}.default.options',
        },
      },
    },
  },
})
