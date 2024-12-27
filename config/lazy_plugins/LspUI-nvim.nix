{ pkgs, helpers, ... }:
let
  LspUI = pkgs.vimUtils.buildVimPlugin {
    name = "lspui";
    src = pkgs.fetchFromGitHub {
      owner = "jinzhongjia";
      repo = "LspUI.nvim";
      rev = "a783d904921f657e003288ad3cab14e3c86d16e7";
      sha256 = "sha256-6RVKT+3laeZc5dSgiHVeK/aCGl7UExoWamPFe5EgBKk=";
    };
  };
in
{
  pkg = LspUI;
  config = ''
    function()
      require("LspUI").setup({})
    end
  '';
}
