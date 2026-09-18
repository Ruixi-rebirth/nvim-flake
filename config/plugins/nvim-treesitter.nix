{ pkgs, ... }:
{
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;
    folding.enable = true;
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      go
      javascript
      json
      lua
      markdown
      markdown_inline
      nix
      python
      rust
      yaml
      toml
      haskell
      c
      cpp
      cmake
      meson
    ];
    luaConfig.post = ''
      -- Treesitter injection for Nix strings (e.g., __raw)
      local nix_injection_query = [[
        ((binding
          attrpath: (attrpath (identifier) @_name)
          expression: (string_expression (string_fragment) @injection.content))
         (#match? @_name "(__raw)$")
         (#set! injection.language "lua"))
      ]]
      local queries = {}
      for _, path in ipairs(vim.treesitter.query.get_files("nix", "injections")) do
        table.insert(queries, table.concat(vim.fn.readfile(path), "\n"))
      end
      table.insert(queries, nix_injection_query)
      vim.treesitter.query.set("nix", "injections", table.concat(queries, "\n"))
    '';
  };
}
