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
              event = "msg_show",
              any = {
                { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
                { find = "%d fewer lines" },
                { find = "%d more lines" },
                { find = 'Agent service not initialized' },
              },
            },
            opts = { skip = true },
          },
        },
        presets = {
          inc_rename = true,
          lsp_doc_border = true,
        },
        lsp = {
          signature = {
            enabled = true,
            auto_open = {
              enabled = false, -- blink-cmp already supports this, so disable it here
            },
          },
        },
      })
    end
  '';
}
