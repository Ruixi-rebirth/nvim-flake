local nvim_lsp = vim.lsp
vim.lsp.enable("nixd")
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
          expr =
          'let flake = builtins.getFlake ("git+file://" + toString ./.); in flake.debug.options // flake.currentSystem.options',
        },
        nixvim = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).packages.${builtins.currentSystem}.default.options',
        },
      },
    },
  },
}

-- 如果当前目录存在 anante.lua 则导入这个文件
local function import_anante()
  local anante_path = vim.fn.getcwd() .. "/.anante.lua"
  if vim.fn.filereadable(anante_path) == 1 then
    dofile(anante_path)
  end
end
