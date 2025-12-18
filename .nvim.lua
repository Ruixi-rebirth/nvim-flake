local nvim_lsp = vim.lsp
nvim_lsp.enable("nixd")
nvim_lsp.config.nixd = {
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
          expr = 'let flake = builtins.getFlake ("git+file://" + toString ./.); in flake.debug.options // flake.currentSystem.options',
        },
        nixvim = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).packages.${builtins.currentSystem}.default.options',
        },
      },
    },
  },
}
