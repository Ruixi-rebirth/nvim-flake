{
  pkgs,
  helpers,
  inputs,
  ...
}:
let
  none-ls-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "none-ls";
    src = inputs.none-ls-nvim;
  };
in
{
  pkg = none-ls-nvim;
  lazy = false;
  dependencies = with pkgs.vimPlugins; [ plenary-nvim ];
  config = ''
    function()
      local function get_formatter_cmd(env_var, default)
        local path = os.getenv(env_var)
        if path and vim.fn.filereadable(path) == 1 then
          return path
        end
        return default
      end

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
            command = get_formatter_cmd("CLANG_FORMAT_PATH", "${pkgs.clang-tools}/bin/clang-format"),
          }),
          require("null-ls").builtins.formatting.cmake_format.with({
            command = "${pkgs.cmake-format}/bin/cmake-format",
          }),
          require("null-ls").builtins.formatting.gn_format.with({
            command = get_formatter_cmd("GN_PATH", "${pkgs.gn}/bin/gn"),
          }),
        },

        on_attach = function(client, bufnr)
          local exclude_ft = { "c", "cpp", "h" }
          local filetype = vim.bo[bufnr].filetype

          if client.supports_method("textDocument/formatting") and not vim.tbl_contains(exclude_ft, filetype) then
            local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
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
