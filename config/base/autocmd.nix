{ lib, ... }:
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
      callback = lib.nixvim.mkRaw ''
        function()
          local util = require("lspconfig.util")
          local path = vim.fn.expand("%:p")
          local function find_repo_root(startpath)
            local repo = vim.fs.find('.repo', { path = startpath, upward = true })[1]
            return repo and vim.fs.dirname(repo) or nil
          end
          local root_dir = find_repo_root(path) or util.find_git_ancestor(path)
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
      callback = lib.nixvim.mkRaw ''
        function()
          pcall(function() vim.cmd("mkview") end)
        end
      '';
    }
    {
      # Restore folding state
      event = [ "BufRead" ];
      pattern = [ "*" ];
      callback = lib.nixvim.mkRaw ''
        function()
          pcall(function() vim.cmd("loadview") end)
        end
      '';
    }
  ];
}
