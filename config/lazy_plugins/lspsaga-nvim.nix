{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.lspsaga-nvim;
  lazy = false;
  dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
  config = ''
    function()
       local colors, kind
       colors = { normal_bg = "#3b4252" }
       require("lspsaga").setup({
          ui = {
             colors = colors,
             kind = kind,
             border = "single",
          },
          outline = {
             win_width = 25,
          },
       })
       vim.cmd([[ colorscheme nord ]])

       local keymap = vim.keymap.set

       -- Lsp finder
       -- Find the symbol definition, implementation, reference.
       -- If there is no implementation, it will hide.
       -- When you use action in finder like open, vsplit, then you can use <C-t> to jump back.
       keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", {silent = true, desc = "Lsp finder"})

       -- Code action
       keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", {silent = true, desc = "Code action"})
       keymap("v", "<leader>ca", "<cmd>Lspsaga code_action<CR>", {silent = true, desc = "Code action"})

       -- Rename
       keymap("n", "gr", "<cmd>Lspsaga rename<CR>", {silent = true, desc = "Rename"})
       -- Rename word in whole project
       keymap("n", "gr", "<cmd>Lspsaga rename ++project<CR>", {silent = true, desc = "Rename in project"})

       -- Peek definition
       keymap("n", "gD", "<cmd>Lspsaga peek_definition<CR>", {silent = true, desc = "Peek definition"})

       -- Go to definition
       keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", {silent = true, desc = "Go to definition"})

       -- Show line diagnostics
       keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>", {silent = true, desc = "Show line diagnostics"})

       -- Show cursor diagnostics
       keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", {silent = true, desc = "Show cursor diagnostic"})

       -- Show buffer diagnostics
       keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", {silent = true, desc = "Show buffer diagnostic"})

       -- Diagnostic jump prev
       keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", {silent = true, desc = "Diagnostic jump prev"})

       -- Diagnostic jump next
       keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", {silent = true, desc = "Diagnostic jump next"})

       -- Goto prev error
       keymap("n", "[E", function()
       require("lspsaga.diagnostic"):goto_prev({severity = vim.diagnostic.severity.ERROR})
       end, {silent = true, desc = "Goto prev error"})

       -- Goto next error
       keymap("n", "]E", function()
       require("lspsaga.diagnostic"):goto_next({severity = vim.diagnostic.severity.ERROR})
       end, {silent = true, desc = "Goto next error"})

       -- Toggle outline
       keymap("n", "ss", "<cmd>Lspsaga outline<CR>", {silent = true, desc = "Toggle outline"})

       -- Hover doc
       keymap("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>", {silent = true, desc = "Hover doc"})

       -- Incoming calls
       keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", {silent = true, desc = "Incoming calls"})

       -- Outgoing calls
       keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", {silent = true, desc = "Outgoing calls"})

       -- Float terminal
       keymap("n", "<A-d>", "<cmd>Lspsaga term_toggle<CR>", {silent = true, desc = "Float terminal"})
       keymap("t", "<A-d>", "<cmd>Lspsaga term_toggle<CR>", {silent = true, desc = "Float terminal"})
    end
  '';
}
