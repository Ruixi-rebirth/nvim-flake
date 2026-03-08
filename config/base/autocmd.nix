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
      # Auto-change directory to project root
      event = [ "FileType" ];
      pattern = [ "*" ];
      callback = lib.nixvim.mkRaw ''
        function()
          local path = vim.fn.expand("%:p")
          -- Skip special buffers
          if path == "" or vim.bo.buftype ~= "" then return end

          -- Find project markers
          local root = vim.fs.find({ ".repo", ".git" }, {
            path = path,
            upward = true,
          })[1]

          if root then
            local root_dir = vim.fs.dirname(root)
            pcall(vim.api.nvim_set_current_dir, root_dir)
          else
            -- Fallback to the directory of the current file
            local file_dir = vim.fn.expand("%:p:h")
            if file_dir and file_dir ~= "" and vim.fn.isdirectory(file_dir) == 1 then
              pcall(vim.api.nvim_set_current_dir, file_dir)
            end
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
