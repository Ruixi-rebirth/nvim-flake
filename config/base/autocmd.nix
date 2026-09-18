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
      callback = lib.nixvim.mkRaw ''
        function(args)
          local bo = vim.bo[args.buf]
          -- Markdown trailing spaces can represent a hard line break.
          if bo.buftype ~= "" or not bo.modifiable or bo.filetype == "markdown" then return end
          vim.api.nvim_buf_call(args.buf, function()
            local view = vim.fn.winsaveview()
            vim.cmd([[silent keepjumps keeppatterns %s/\s\+$//e]])
            vim.fn.winrestview(view)
          end)
        end
      '';
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
        "WinResized"
        "BufEnter"
      ];
      pattern = [ "*" ];
      callback = lib.nixvim.mkRaw ''
        function()
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_win_get_config(win).relative == ""
              and vim.bo[buf].buftype == ""
              and vim.bo[buf].filetype ~= "leetcode.nvim"
            then
              vim.wo[win].colorcolumn = vim.api.nvim_win_get_width(win) < 120 and "" or "80,120"
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
