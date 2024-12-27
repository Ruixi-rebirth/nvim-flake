{
  pkgs,
  inputs,
  helpers,
  ...
}:
let
  # vim-translator = pkgs.vimUtils.buildVimPlugin {
  #   name = "vim-translator";
  #   src = inputs.vim-translator;
  # };
  vim-translator = pkgs.vimUtils.buildVimPlugin {
    name = "vim-translator";
    src = inputs.vim-translator;
    postPatch = ''
      sed -i "s/executable('g:python3_host_prog')/executable(g:python3_host_prog)/" \
        autoload/translator.vim
    '';
  };

in
{
  pkg = vim-translator;
  lazy = false;
  keys = helpers.mkRaw ''
    {
      { "<leader>d", "<Plug>TranslateW", desc = "Display translation in a window", },
      { "<leader>d", "<Plug>TranslateWV", desc = "Display translation in a window", mode = {'v'} },
    }
  '';
  config = '''';
}
