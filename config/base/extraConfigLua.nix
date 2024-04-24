{
  config = {
    extraConfigLua = ''
      --  Add '-' to the list of characters considered part of a keyword
      vim.cmd([[set iskeyword+=-]])                                                
      -- Allow moving between lines using arrow keys and h/l when at the start/end of a line
      vim.cmd("set whichwrap+=<,>,[,],h,l")

      local local_nvimrc = vim.fn.getcwd()..'/.nvim.lua'
      if vim.loop.fs_stat(local_nvimrc) then
        vim.cmd('source '..local_nvimrc)
      end
    '';
  };
}
