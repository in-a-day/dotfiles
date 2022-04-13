local M = {}

local utils = require "core.utils"

local map = vim.keymap.set
local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local opts = { noremap = true, silent = true }

-- vim.keymap.set did not work for this
map("", "<Space>", "<Nop>", opts)
--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--========================= Normal ==========================--

-- ESC cancel higlight
map("n", "<ESC>", ":nohlsearch<CR>", opts)

-- insert current time
map("n", "<A-i>", ":put =strftime('%Y-%m-%d %H:%M:%S')<CR>", opts)

if utils.is_available "smart-splits.nvim" then
  -- Better window navigation
  local ss = require("smart-splits")
  map("n", "<A-h>", ss.resize_left)
  map("n", "<A-j>", ss.resize_down)
  map("n", "<A-k>", ss.resize_up)
  map("n", "<A-l>", ss.resize_right)
  -- moving between splits
  map('n', '<C-h>', ss.move_cursor_left)
  map('n', '<C-j>', ss.move_cursor_down)
  map('n', '<C-k>', ss.move_cursor_up)
  map('n', '<C-l>', ss.move_cursor_right)
end

-- Navigate buffers
if utils.is_available "bufferline.nvim" then
  map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>")
  map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>")
  -- move current buffer location
  map("n", "}", "<cmd>BufferLineMoveNext<cr>")
  map("n", "{", "<cmd>BufferLineMovePrev<cr>")
else
  map("n", "<S-l>", "<cmd>bnext<CR>")
  map("n", "<S-h>", "<cmd>bprevious<CR>")
end

-- Norg
if utils.is_available "neorg" then
  map('n', '<leader>nv', "<cmd>Neorg gtd views<cr>")
  map('n', '<leader>ne', "<cmd>Neorg gtd edit<cr>")
  map('n', '<leader>nc', "<cmd>Neorg gtd capture<cr>")
end

-- LSP
map("n", "gD", vim.lsp.buf.declaration)
map("n", "gd", vim.lsp.buf.definition, { desc = "Show the definition of current function" })
map("n", "gI", vim.lsp.buf.implementation)
-- map("n", "gr", vim.lsp.buf.references)
map("n", "go", vim.diagnostic.open_float)
map("n", "gl", vim.diagnostic.open_float)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "gk", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "gj", vim.diagnostic.goto_next)
map("n", "K", vim.lsp.buf.hover)
-- <leader>rn: legacy binding here for backwards compatibility but not in which-key (see <leader>lr)
map("n", "<leader>rn", vim.lsp.buf.rename)

-- code action menu
map("n", "<leader>xa", "<cmd>CodeActionMenu<CR>")

-- lsp trouble
map("n", "<leader>xx", "<cmd>Trouble<cr>", {silent = true, noremap = true})
map("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", {silent = true, noremap = true})
map("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", {silent = true, noremap = true})
map("n", "<leader>xl", "<cmd>Trouble loclist<cr>", {silent = true, noremap = true})
map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", {silent = true, noremap = true})
map("n", "gR", "<cmd>Trouble lsp_references<cr>", {silent = true, noremap = true})
map("n", "gr", "<cmd>Trouble lsp_references<cr>", {silent = true, noremap = true})

-- lsp preview
if utils.is_available "goto-preview" then
  map("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
  map("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
  map("n", "gq", "<cmd>lua require('goto-preview').close_all_win()<CR>")
  map("n", "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>")
end


-- ForceWrite
map("n", "<C-s>", "<cmd>w!<CR>")

-- ForceQuit
map("n", "<C-q>", "<cmd>q!<CR>")

-- Terminal
if utils.is_available "nvim-toggleterm.lua" then
  map("n", "<C-\\>", "<cmd>ToggleTerm<CR>")
end

-- Normal Leader Mappings --
-- NOTICE: if changed, update configs/which-key-register.lua
-- Allows easy user modifications when just overriding which-key
-- But allows bindings to work for users without which-key
if not utils.is_available "which-key.nvim" then
  -- Standard Operations
  map("n", "<leader>w", "<cmd>w<CR>")
  map("n", "<leader>q", "<cmd>q<CR>")
  map("n", "<leader>h", "<cmd>nohlsearch<CR>")

  if utils.is_available "vim-bbye" then
    map("n", "<leader>c", "<cmd>Bdelete!<CR>")
  end

  -- Packer
  map("n", "<leader>pc", "<cmd>PackerCompile<cr>")
  map("n", "<leader>pi", "<cmd>PackerInstall<cr>")
  map("n", "<leader>ps", "<cmd>PackerSync<cr>")
  map("n", "<leader>pS", "<cmd>PackerStatus<cr>")
  map("n", "<leader>pu", "<cmd>PackerUpdate<cr>")

  -- LSP
  map("n", "<leader>lf", vim.lsp.buf.formatting_sync)
  map("n", "<leader>li", "<cmd>LspInfo<cr>")
  map("n", "<leader>lI", "<cmd>LspInstallInfo<cr>")
  map("n", "<leader>la", vim.lsp.buf.code_action)
  map("n", "<leader>lr", vim.lsp.buf.rename)
  map("n", "<leader>ld", vim.diagnostic.open_float)

  -- NeoTree
  if utils.is_available "neo-tree.nvim" then
    map("n", "<leader>e", "<cmd>Neotree toggle<CR>")
    map("n", "<leader>o", "<cmd>Neotree focus<CR>")
  end

  -- Dashboard
  if utils.is_available "dashboard-nvim" then
    map("n", "<leader>d", "<cmd>Dashboard<CR>")
    map("n", "<leader>fn", "<cmd>DashboardNewFile<CR>")
    map("n", "<leader>Sl", "<cmd>SessionLoad<CR>")
    map("n", "<leader>Ss", "<cmd>SessionSave<CR>")
  end

  -- GitSigns
  if utils.is_available "gitsigns.nvim" then
    map("n", "<leader>gj", function()
      require("gitsigns").next_hunk()
    end)
    map("n", "<leader>gk", function()
      require("gitsigns").prev_hunk()
    end)
    map("n", "<leader>gl", function()
      require("gitsigns").blame_line()
    end)
    map("n", "<leader>gp", function()
      require("gitsigns").preview_hunk()
    end)
    map("n", "<leader>gh", function()
      require("gitsigns").reset_hunk()
    end)
    map("n", "<leader>gr", function()
      require("gitsigns").reset_buffer()
    end)
    map("n", "<leader>gs", function()
      require("gitsigns").stage_hunk()
    end)
    map("n", "<leader>gu", function()
      require("gitsigns").undo_stage_hunk()
    end)
    map("n", "<leader>gd", function()
      require("gitsigns").diffthis()
    end)
  end

  -- Telescope
  if utils.is_available "telescope.nvim" then
    map("n", "<leader>fw", function()
      require("telescope.builtin").live_grep()
    end)
    map("n", "<leader>gt", function()
      require("telescope.builtin").git_status()
    end)
    map("n", "<leader>gb", function()
      require("telescope.builtin").git_branches()
    end)
    map("n", "<leader>gc", function()
      require("telescope.builtin").git_commits()
    end)
    map("n", "<leader>ff", function()
      require("telescope.builtin").find_files()
    end)
    map("n", "<leader>fb", function()
      require("telescope.builtin").buffers()
    end)
    map("n", "<leader>fh", function()
      require("telescope.builtin").help_tags()
    end)
    map("n", "<leader>fm", function()
      require("telescope.builtin").marks()
    end)
    map("n", "<leader>fo", function()
      require("telescope.builtin").oldfiles()
    end)
    map("n", "<leader>sb", function()
      require("telescope.builtin").git_branches()
    end)
    map("n", "<leader>sh", function()
      require("telescope.builtin").help_tags()
    end)
    map("n", "<leader>sm", function()
      require("telescope.builtin").man_pages()
    end)
    map("n", "<leader>sn", function()
      require("telescope").extensions.notify.notify()
    end)
    map("n", "<leader>sr", function()
      require("telescope.builtin").registers()
    end)
    map("n", "<leader>sk", function()
      require("telescope.builtin").keymaps()
    end)
    map("n", "<leader>sc", function()
      require("telescope.builtin").commands()
    end)
    map("n", "<leader>ls", function()
      require("telescope.builtin").lsp_document_symbols()
    end)
    map("n", "<leader>lR", function()
      require("telescope.builtin").lsp_references()
    end)
    map("n", "<leader>lD", function()
      require("telescope.builtin").diagnostics()
    end)
  end

  -- Comment
  if utils.is_available "Comment.nvim" then
    -- Linewise toggle current line using C-/
    map('i', '<C-_>', require("Comment.api").toggle_current_linewise)
    map('n', '<C-_>', require("Comment.api").toggle_current_linewise)
  end

  -- Terminal
  if utils.is_available "nvim-toggleterm.lua" then
    map("n", "<leader>gg", function()
      utils.toggle_term_cmd "lazygit"
    end)
    map("n", "<leader>tn", function()
      utils.toggle_term_cmd "node"
    end)
    map("n", "<leader>tu", function()
      utils.toggle_term_cmd "ncdu"
    end)
    map("n", "<leader>tt", function()
      utils.toggle_term_cmd "htop"
    end)
    map("n", "<leader>tp", function()
      utils.toggle_term_cmd "python"
    end)
    map("n", "<leader>tl", function()
      utils.toggle_term_cmd "lazygit"
    end)
    map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>")
    map("n", "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>")
    map("n", "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>")
  end

  -- SymbolsOutline
  if utils.is_available "symbols-outline.nvim" then
    map("n", "<leader>lS", "<cmd>SymbolsOutline<CR>")
  end
end

--========================= Visual ==========================--

-- Comment
if utils.is_available "Comment.nvim" then
  map('x', '<C-_>', function()
    require("Comment.api").toggle_linewise_op(vim.fn.visualmode())
  end)
end

-- Visual Block --
-- Move text up and down
map("x", "J", "<cmd>move '>+1<CR>gv-gv")
map("x", "K", "<cmd>move '<-2<CR>gv-gv")

-- disable Ex mode:
map("n", "Q", "<Nop>")

function _G.set_terminal_keymaps()
  vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], {})
  vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], {})
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], {})
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], {})
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], {})
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], {})
end

augroup("TermMappings", {})
cmd("TermOpen", {
  desc = "Set terminal keymaps",
  group = "TermMappings",
  callback = _G.set_terminal_keymaps,
})

return M