{
  config = {
    extraConfigLua = ''
      --  Add '-' to the list of characters considered part of a keyword
      vim.cmd([[set iskeyword+=-]])                                                
      -- Allow moving between lines using arrow keys and h/l when at the start/end of a line
      vim.cmd("set whichwrap+=<,>,[,],h,l")

      local util = require 'lspconfig.util'
      local function load_project_nvim_config()
          local root_dir = function(fname)
              return util.find_git_ancestor(fname)
          end
          local current_file = vim.fn.expand('%:p')
          local project_root = root_dir(current_file)
          if project_root then
              local nvim_config_path = project_root .. '/.nvim.lua'
              if vim.loop.fs_stat(nvim_config_path) then
                  vim.cmd('source ' .. nvim_config_path)
              end
          end
      end
      load_project_nvim_config()
    '';
  };
}
