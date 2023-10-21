{
  config = {
    globals = {
      mapleader = " ";
    };
    keymaps = [
      {
        mode = "";
        key = "<Space>";
        action = "<Nop>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "S";
        action = ":w<CR>";
        options.desc = "save file";
        options.silent = true;
      }
      {
        mode = "n";
        key = "Q";
        action = ":qa<CR>";
        options.desc = "quit neovim";
        options.silent = true;
      }
      {
        mode = "i";
        key = "jk";
        action = "<ESC>";
        options.desc = "exit insert mode";
        options.silent = true;
      }
      # Better window navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.silent = true;
      }
      # Naviagate buffers
      {
        mode = "n";
        key = "<TAB>";
        action = ":bnext<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<S-TAB>";
        action = ":bprevious<CR>";
        options.silent = true;
      }
      # Stay in indent mode
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options.silent = true;
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options.silent = true;
      }
      # Move text up and down
      {
        mode = "x";
        key = "J";
        action = ":move '>+1<CR>gv-gv";
        options.silent = true;
      }
      {
        mode = "x";
        key = "K";
        action = ":move '<-2<CR>gv-gv";
        options.silent = true;
      }
      {
        mode = "v";
        key = "J";
        action = ":move '>+1<CR>gv-gv";
        options.silent = true;
      }
      {
        mode = "v";
        key = "K";
        action = ":move '<-2<CR>gv-gv";
        options.silent = true;
      }
      # Better split screen
      {
        mode = "";
        key = "s";
        action = "<Nop>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "sl";
        action = ":set splitright<CR>:vsplit<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "sh";
        action = ":set nosplitright<CR>:vsplit<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "sk";
        action = ":set nosplitbelow<CR>:split<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "sj";
        action = ":set splitbelow<CR>:split<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<C-=>";
        action = "<C-w>=";
        options.desc = "average adjustment window";
        options.silent = true;
      }
      # Swap and move windows
      {
        mode = "n";
        key = "<Space>h";
        action = "<C-w>H";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<Space>j";
        action = "<C-w>J";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<Space>k";
        action = "<C-w>K";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<Space>l";
        action = "<C-w>L";
        options.silent = true;
      }
      # Adjust the direction of the split screen
      {
        mode = "n";
        key = ",";
        action = "<C-w>t<C-w>K";
        options.silent = true;
      }
      {
        mode = "n";
        key = ".";
        action = "<C-w>t<C-w>H";
        options.silent = true;
      }
      # Resize the window
      {
        mode = "n";
        key = "<C-Down>";
        action = ":resize -2<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<C-Up>";
        action = ":resize +2<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = ":vertical resize -2<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = ":vertical resize +2<CR>";
        options.silent = true;
      }
      # Better viewing of search results
      {
        mode = "n";
        key = "<Space><CR>";
        action = ":nohlsearch<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "n";
        action = "nzz";
        options.silent = true;
      }
      {
        mode = "n";
        key = "N";
        action = "Nzz";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<C-n>";
        action = ":tabnew<CR>";
        options.desc = "new tab";
        options.silent = true;
      }
      # Misc
      {
        mode = "n";
        key = "<C-u>";
        action = "5k";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<C-d>";
        action = "5j";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<C-.>";
        action = "$";
        options.silent = true;
      }
      {
        mode = "i";
        key = "<C-.>";
        action = "<ESC>$";
        options.silent = true;
      }
      {
        mode = "x";
        key = "<C-.>";
        action = "$";
        options.silent = true;
      }
      {
        mode = "v";
        key = "<C-.>";
        action = "$";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<C-,>";
        action = "^";
        options.silent = true;
      }
      {
        mode = "i";
        key = "<C-,>";
        action = "<ESC>^";
        options.silent = true;
      }
      {
        mode = "x";
        key = "<C-,>";
        action = "^";
        options.silent = true;
      }
      {
        mode = "v";
        key = "<C-,>";
        action = "^";
        options.silent = true;
      }
    ];
  };
}
