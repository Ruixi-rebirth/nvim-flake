{ pkgs, inputs, ... }:
let
  vim-translator-pkg = pkgs.vimUtils.buildVimPlugin {
    name = "vim-translator";
    src = inputs.vim-translator;
    postPatch = ''
      sed -i "s/executable('g:python3_host_prog')/executable(g:python3_host_prog)/" \
        autoload/translator.vim
    '';
  };
in
{
  extraPlugins = [ vim-translator-pkg ];

  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = vim-translator-pkg.name;
      lazy = true;
      keys = [
        {
          __unkeyed-1 = "<leader>d";
          __unkeyed-2 = "<Plug>TranslateW";
          desc = "Display translation in a window";
        }
        {
          __unkeyed-1 = "<leader>d";
          __unkeyed-2 = "<Plug>TranslateWV";
          mode = [ "v" ];
          desc = "Display translation in a window";
        }
      ];
    }
  ];
}
