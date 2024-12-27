{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.noice-nvim;
  dependencies = with pkgs.vimPlugins; [ nui-nvim ];
  config = ''
    function()
       require("noice").setup({
          routes = {
             {
                filter = {
                   event = 'msg_show',
                   any = {
                      { find = '%d+L, %d+B' },
                      { find = '; after #%d+' },
                      { find = '; before #%d+' },
                      { find = '%d fewer lines' },
                      { find = '%d more lines' },
                   },
                },
                opts = { skip = true },
             },
          },
          presets = {
            inc_rename = true, 
            lsp_doc_border = true, 
          },
       })
    end
  '';
}
