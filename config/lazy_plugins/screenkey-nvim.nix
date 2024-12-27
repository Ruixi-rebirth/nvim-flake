{ pkgs, helpers, ... }:
let
  screenkey-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "screenkey-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "NStefan002";
      repo = "screenkey.nvim";
      rev = "16390931d847b1d5d77098daccac4e55654ac9e2";
      sha256 = "sha256-EGyIkWcQbCurkBbeHpXvQAKRTovUiNx1xqtXmQba8Gg=";
    };
  };
in
{
  pkg = screenkey-nvim;
  config = ''
    function()
      require("screenkey").setup({})
    end
  '';
}
