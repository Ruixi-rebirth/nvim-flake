{ helpers, ... }:
{
  autoCmd = [
    {
      # Jump to the last edit position
      event = [ "BufReadPost" ];
      pattern = [ "*" ];
      command = ''
        if line("'\"") > 1 && line("'\"") <= line("$") |
        	exe "normal! g`\""
        endif
      '';
    }
    {
      # Automatically remove trailing whitespace before saving the file
      event = [ "BufWritePre" ];
      pattern = [ "*" ];
      command = "%s/\\s\\+$//e";
    }
    {
      event = [ "FileType" ];
      pattern = [ "*" ];
      callback = helpers.mkRaw ''
        function()
          local util = require("lspconfig.util")
          local root_dir = util.find_git_ancestor(vim.fn.expand("%:p"))
          if root_dir then
            pcall(function() vim.cmd('cd ' .. root_dir) end)
          else
            local file_dir = vim.fn.expand('%:p:h')
            pcall(function() vim.cmd('cd ' .. file_dir) end)
          end
        end
      '';
    }
    {
      # Save folding state
      event = [ "BufWinLeave" ];
      pattern = [ "*" ];
      callback = helpers.mkRaw ''
        function()
          pcall(function() vim.cmd("mkview") end)
        end
      '';
    }
    {
      # Restore folding state
      event = [ "BufRead" ];
      pattern = [ "*" ];
      callback = helpers.mkRaw ''
        function()
          pcall(function() vim.cmd("loadview") end)
        end
      '';
    }
  ];
}
