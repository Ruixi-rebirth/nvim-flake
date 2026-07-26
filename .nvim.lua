local nvim_lsp = vim.lsp
nvim_lsp.enable("nixd")

local flake_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")

nvim_lsp.config.nixd = {
  settings = {
    nixd = {
      nixpkgs = {
        expr = 'import (builtins.getFlake ("git+file://' .. flake_root .. '")).inputs.nixpkgs { }',
      },
      formatting = {
        command = { "nixfmt" },
      },
      options = {
        flake_parts = {
          expr = 'let flake = builtins.getFlake ("git+file://'
            .. flake_root
            .. '"); in flake.debug.options // flake.currentSystem.options',
        },
        nixvim = {
          expr = '(builtins.getFlake ("git+file://'
            .. flake_root
            .. '")).packages.${builtins.currentSystem}.default.options',
        },
      },
    },
  },
}
