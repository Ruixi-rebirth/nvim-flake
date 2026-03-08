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
  };
}
