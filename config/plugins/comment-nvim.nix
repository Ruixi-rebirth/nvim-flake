{ lib, ... }:
{
  plugins.comment = {
    enable = true;
    settings = {
      pre_hook = lib.nixvim.mkRaw "require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()";
      padding = true;
      sticky = true;
      toggler = {
        line = "gcc";
        block = "gbc";
      };
      opleader = {
        line = "gc";
        block = "gb";
      };
      extra = {
        above = "gcO";
        below = "gco";
        eol = "gcA";
      };
      mappings = {
        basic = true;
        extra = true;
      };
    };

    lazyLoad.settings = {
      event = [ "BufReadPost" ];
    };
  };

  plugins.ts-context-commentstring = {
    enable = true;
  };
}
