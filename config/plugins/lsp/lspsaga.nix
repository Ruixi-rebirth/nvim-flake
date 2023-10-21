{
  plugins.lspsaga = {
    enable = true;
    ui = {
      border = "single";
    };
    outline = {
      autoClose = true;
      autoPreview = true;
      winWidth = 25;
      winPosition = "right";
      keys = { };
    };
    codeAction = {
      extendGitSigns = true;
      showServerName = true;
      keys = { };
    };
    definition = {
      height = 0.5;
      width = 0.6;
    };
    diagnostic = {
      keys = { };
    };
    finder = {
      keys = { };
    };
    rename = {
      keys = { };
    };
    scrollPreview = {
      scrollDown = "<C-f>";
      scrollUp = "<C-b>";
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "gh";
      action = "<cmd>Lspsaga lsp_finder<cr>";
      options.silent = true;
      options.desc = ''
        Lsp finder find the symbol definition implement reference
        if there is no implement it will hide
        when you use action in finder like open vsplit then you can
        use <C-t> to jump back
      '';
    }
    {
      mode = "n";
      key = "<leader>ca";
      action = "<cmd>Lspsaga code_action<CR>";
      options.silent = true;
      options.desc = ''
        Code action
      '';
    }
    {
      mode = "v";
      key = "<leader>ca";
      action = "<cmd>Lspsaga code_action<CR>";
      options.silent = true;
      options.desc = ''
        Code action
      '';
    }
    {
      mode = "n";
      key = "gr";
      action = "<cmd>Lspsaga rename<CR>";
      options.silent = true;
      options.desc = ''
        Rename
      '';
    }
    {
      mode = "n";
      key = "gr";
      action = "<cmd>Lspsaga rename ++project<CR>";
      options.silent = true;
      options.desc = ''
        Rename word in whole project
      '';
    }
    {
      mode = "n";
      key = "gD";
      action = "<cmd>Lspsaga peek_definition<CR>";
      options.silent = true;
      options.desc = ''
        Peek Definition
        you can edit the definition file in this float window
        also support open/vsplit/etc operation check definition_action_keys
      '';
    }
    {
      mode = "n";
      key = "gd";
      action = "<cmd>Lspsaga goto_definition<CR>";
      options.silent = true;
      options.desc = ''
        Go to Definition
      '';
    }
    {
      mode = "n";
      key = "<leader>sl";
      action = "<cmd>Lspsaga show_line_diagnostics<CR>";
      options.silent = true;
      options.desc = ''
        Show line diagnostics you can pass argument ++unfocus to make
        show_line_diagnostics float window unfocus
      '';
    }
    {
      mode = "n";
      key = "<leader>sc";
      action = "<cmd>Lspsaga show_cursor_diagnostics<CR>";
      options.silent = true;
      options.desc = ''
        Show cursor diagnostic
        also like show_line_diagnostics  support pass ++unfocus
      '';
    }
    {
      mode = "n";
      key = "<leader>sb";
      action = "<cmd>Lspsaga show_buf_diagnostics<CR>";
      options.silent = true;
      options.desc = ''
        Show buffer diagnostic
      '';
    }
    {
      mode = "n";
      key = "[e";
      action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
      options.silent = true;
      options.desc = ''
        Diagnostic jump can use `<c-o>` to jump back
      '';
    }
    {
      mode = "n";
      key = "]e";
      action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
      options.silent = true;
      options.desc = ''
        Diagnostic jump can use `<c-o>` to jump back
      '';
    }
    {
      mode = "n";
      key = "[E";
      action = ''
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end
      '';
      options.silent = true;
    }
    {
      mode = "n";
      key = "]E";
      action = ''
        function()
          require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end
      '';
      options.silent = true;
    }
    {
      mode = "n";
      key = "ss";
      action = "<cmd>Lspsaga outline<CR>";
      options.silent = true;
      options.desc = ''
        Toggle Outline
      '';
    }
    {
      mode = "n";
      key = "K";
      action = "<cmd>Lspsaga hover_doc ++keep<CR>";
      options.silent = true;
      options.desc = ''
        Hover Doc:
        if there has no hover will have a notify no information available
        to disable it just Lspsaga hover_doc ++quiet
        press twice it will jump into hover window
        `keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")`
        if you want keep hover window in right top you can use ++keep arg
        notice if you use hover with ++keep you press this keymap it will
        close the hover window .if you want jump to hover window must use
        wincmd command <C-w>w
      '';
    }
    {
      mode = "n";
      key = "<Leader>ci";
      action = "<cmd>Lspsaga incoming_calls<CR>";
      options.silent = true;
      options.desc = ''
        Callhierarchy
      '';
    }
    {
      mode = "n";
      key = "<Leader>co";
      action = "<cmd>Lspsaga outgoing_calls<CR>";
      options.silent = true;
      options.desc = ''
        Callhierarchy
      '';
    }
    {
      mode = "n";
      key = "<A-d>";
      action = "<cmd>Lspsaga term_toggle<CR>";
      options.silent = true;
      options.desc = ''
        Float terminal
      '';
    }
    {
      mode = "t";
      key = "<A-d>";
      action = "<cmd>Lspsaga term_toggle<CR>";
      options.silent = true;
      options.desc = ''
        Float terminal
      '';
    }
  ];
}
