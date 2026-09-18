{ ... }:
{
  plugins.toggleterm = {
    enable = true;

    settings = {
      # size can be a number or function which is passed the current terminal
      size.__raw = ''
        function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end
      '';
      # NixVim treats this option as a Lua expression, not a quoted string.
      open_mapping = "[[<c-\\>]]";
      hide_numbers = true; # hide the number column in toggleterm buffers
      shade_filetypes = [ ];
      shade_terminals = false;
      # shading_factor = "<number>", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true;
      insert_mappings = true; # whether or not the open mapping applies in insert mode
      terminal_mappings = true; # whether or not the open mapping applies in the opened terminals
      persist_size = true;
      direction = "horizontal"; # 'vertical' | 'horizontal' | 'window' | 'float'
      close_on_exit = true; # close the terminal window when the process exits
      shell.__raw = "vim.o.shell"; # change the default shell

      # This field is only relevant if direction is set to 'float'
      float_opts = {
        # The border key is *almost* the same as 'nvim_open_win'
        # see :h nvim_open_win for details on borders however
        # the 'curved' border is a custom border type
        # not natively supported but implemented in this plugin.
        border = "single"; # 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        width = 80;
        height = 20;
        winblend = 0;
        highlights = {
          border = "Normal";
          background = "Normal";
        };
      };

      winbar = {
        enabled = false;
        name_formatter.__raw = ''
          function(term) --  term: Terminal
            return term.name
          end
        '';
      };
    };

    luaConfig.post = ''
      function runFile()
        local ft = vim.bo.filetype
        local filename = vim.api.nvim_buf_get_name(0)
        if ft == "go" and filename == "" then
          vim.notify("Save the Go file before running it", vim.log.levels.WARN)
          return
        end
        local run_cmd = {
          go = "go run " .. vim.fn.shellescape(filename),
          rust = "cargo run",
          cpp = "cppup run",
        }
        local cmd = run_cmd[ft]
        if not cmd then
          vim.notify("No run command defined for filetype: " .. ft, vim.log.levels.WARN)
          return
        end
        local exe = cmd:match("^(%S+)")
        if vim.fn.executable(exe) == 0 then
          vim.notify("Command not found: " .. exe, vim.log.levels.ERROR)
          return
        end
        local start_dir = filename ~= "" and vim.fs.dirname(filename) or vim.fn.getcwd()
        local markers = {
          go = { "go.mod", "go.work" },
          rust = { "Cargo.toml" },
        }
        local root = markers[ft] and vim.fs.root(start_dir, markers[ft]) or nil
        -- Unknown runners (such as cppup) keep the user's current directory.
        root = root or vim.fn.getcwd()
        -- The existing terminal may still be in another project's directory.
        -- Change the shell's actual cwd on every run, not just at creation.
        require("toggleterm").exec(
          "clear; cd " .. vim.fn.shellescape(root) .. " && " .. cmd,
          1, nil, root, nil, nil, false
        )
      end

      vim.keymap.set("n", "<space>r", "<cmd>lua runFile()<CR>", { noremap = true, silent = true, desc = "Run current file" })

      function _G.toggle_new_terminal()
        require("toggleterm.terminal").Terminal:new():toggle()
      end

      function _G.kill_curr_terminal()
        local id = vim.b.toggle_number
        if id then
          require("toggleterm.terminal").get(id):shutdown()
        else
          if vim.bo.buftype == "terminal" then vim.cmd("bdelete!") end
        end
      end

      vim.keymap.set({ "n", "t" }, "<C-S-\\>", _G.toggle_new_terminal, { desc = "New terminal" })
      vim.keymap.set({ "n", "t" }, "<C-|>", _G.toggle_new_terminal, { desc = "New terminal" })
      vim.keymap.set({ "n", "t" }, "<C-q>", _G.kill_curr_terminal, { desc = "Kill terminal" })

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-w>h", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-w>j", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-w>k", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-w>l", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
    '';

    lazyLoad.enable = false;
  };
}
