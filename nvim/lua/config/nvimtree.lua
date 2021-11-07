local M = {}

function M.setup()
  local utils = require('config.utils')
  local plugins = {
    'nvim-tree'
  }

	local tree_ok, tree = pcall(require, "nvim-tree")
	if tree_ok then
    tree.setup{}
	end
  -- Hide statusline in nvim-tree buffer/tabs.
  vim.cmd("au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname(\"%\") == \"NvimTree\" | set laststatus=0 | else | set laststatus=2 | endif")
end


return M
