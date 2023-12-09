{
  config = {
    plugins.none-ls = {
      enable = true;
      sources = {
        formatting = {
          nixpkgs_fmt.enable = true;
          beautysh.enable = true;
          rustfmt.enable = true;
          prettier = {
            disableTsServerFormatter = true;
            enable = true;
          };
          gofmt.enable = true;
          fourmolu.enable = true;
        };
      };
      onAttach = ''
        function(client, bufnr)
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
        end
      '';
    };
  };
}
