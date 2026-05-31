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
      # Auto-change directory to project root (.git fallback)
      event = [ "FileType" ];
      pattern = [ "*" ];
      callback = lib.nixvim.mkRaw ''
        function()
          local path = vim.fn.expand("%:p")
          if path == "" or vim.bo.buftype ~= "" then return end

          local root = vim.fs.find({ ".repo", ".git" }, {
            path = path,
            upward = true,
          })[1]

          if root then
            pcall(vim.api.nvim_set_current_dir, vim.fs.dirname(root))
          else
            local file_dir = vim.fn.expand("%:p:h")
            if file_dir and file_dir ~= "" and vim.fn.isdirectory(file_dir) == 1 then
              pcall(vim.api.nvim_set_current_dir, file_dir)
            end
          end
        end
      '';
    }
    {
      # Override cwd with LSP root_dir when LSP attaches
      event = [ "LspAttach" ];
      pattern = [ "*" ];
      callback = lib.nixvim.mkRaw ''
        function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.config.root_dir then
            pcall(vim.api.nvim_set_current_dir, client.config.root_dir)
          end
        end
      '';
    }
    {
      # Hide colorcolumn on narrow windows
      event = [
        "VimResized"
        "BufEnter"
      ];
      pattern = [ "*" ];
      callback = lib.nixvim.mkRaw ''
        function()
          if vim.o.columns < 120 then
            vim.opt_local.colorcolumn = {}
          else
            vim.opt_local.colorcolumn = { "80", "120" }
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
