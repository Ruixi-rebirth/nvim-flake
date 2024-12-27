{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.none-ls-nvim;
  lazy = false;
  dependencies = with pkgs.vimPlugins; [ plenary-nvim ];
  config = ''
    function()
      require("null-ls").setup({
        sources = {
          -- you must download code formatter by yourself!
          require("null-ls").builtins.formatting.black.with({
            command = "${pkgs.black}/bin/black",
          }),
          require("null-ls").builtins.formatting.prettier.with({
            command = "${pkgs.nodePackages.prettier}/bin/prettier",
          }),
          require("null-ls").builtins.formatting.gofumpt.with({
            command = "${pkgs.gofumpt}/bin/gofumpt",
          }),
          require("null-ls").builtins.formatting.nixpkgs_fmt.with({
            command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt",
          }),
          require("null-ls").builtins.formatting.shfmt.with({
            command = "${pkgs.shfmt}/bin/shfmt",
          }),
          require("null-ls").builtins.formatting.stylua.with({
            command = "${pkgs.stylua}/bin/stylua",
            extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          }),
          require("null-ls").builtins.formatting.clang_format.with({
            command = "${pkgs.clang-tools}/bin/clang-format",
          }),
          require("null-ls").builtins.formatting.cmake_format.with({
            command = "${pkgs.cmake-format}/bin/cmake-format",
          }),
        },

        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = vim.api.nvim_create_augroup("LspFormatting", {}), buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("LspFormatting", {}),
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end
        end,
      })
    end
  '';
}
