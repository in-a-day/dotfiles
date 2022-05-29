local M = {}

local options = {
  belloff = "all",
  fileencoding = "utf-8",                     -- File content encoding for the buffer
  spelllang = "en",                           -- Support US english
  clipboard = "unnamedplus",                  -- Connection to the system clipboard
  mouse = "a",                                -- Enable mouse support
  signcolumn = "no",                          -- Hide the sign column

  -- foldmethod = "expr",                        -- Treesitter fold
  -- foldexpr = "nvim_treesitter#foldexpr()",
  foldlevel = 99,
  foldlevelstart = 99,
  foldcolumn = "0",

  completeopt = { "menuone", "noselect", "menuone" },    -- Options for insert mode completion
  colorcolumn = "99999",                      -- Fix for the indentline problem
  backup = false,                             -- Disable making a backup file
  hidden = true,                              -- Ignore unsaved buffers
  hlsearch = true,                            -- Highlight all the matches of search pattern
  ignorecase = true,                          -- Case insensitive searching
  smartcase = true,                           -- Case sensitivie searching
  spell = false,                              -- Disable spelling checking and highlighting
  showmode = false,                           -- Disable showing modes in command line

  -- indent
  autoindent = true,
  expandtab = true,
  shiftwidth = 2,
  smartindent = true,
  softtabstop = 2,
  tabstop = 2,

  splitbelow = true,                          -- Splitting a new window below the current one
  splitright = true,                          -- Splitting a new window at the right of the current one
  swapfile = false,                           -- Disable use of swapfile for the buffer
  termguicolors = true,                       -- Enable 24-bit RGB color in the TUI
  undofile = true,                            -- Enable persistent undo
  writebackup = false,                        -- Disable making a backup before overwriting a file
  cursorline = true,                          -- Highlight the text line of the cursor
  number = true,                              -- Show numberline
  relativenumber = true,                      -- Show relative numberline
  wrap = false,                               -- Disable wrapping of lines longer than the width of window
  conceallevel = 0,                           -- Show text normally
  cmdheight = 1,                              -- Number of screen lines to use for the command line
  scrolloff = 2,                              -- Number of lines to keep above and below the cursor
  sidescrolloff = 2,                          -- Number of columns to keep at the sides of the cursor
  pumheight = 10,                             -- Height of the pop up menu
  history = 100,                              -- Number of commands to remember in a history table
  timeoutlen = 300,                           -- Length of time to wait for a mapped sequence
  updatetime = 300,                           -- Length of time to wait before triggering the plugin
  fillchars = { eob = " " },                  -- Disable `~` on nonexistent lines
  list = true, -- show whitespace
  listchars = {
    nbsp = "⦸", -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
    extends = "»", -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
    precedes = "«", -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
    tab = "▷⋯", -- WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7) + MIDLINE HORIZONTAL ELLIPSIS (U+22EF, UTF-8: E2 8B AF)
  },
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.shortmess:append "c"
vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.opt.fillchars:append({
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┨',
  vertright = '┣',
  verthoriz = '╋',
})

vim.cmd([[
syntax enable
syntax on
filetype plugin on
filetype plugin indent on
]])

local function foldtext()
  local line = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]
  local idx = vim.v.foldstart + 1
  while string.find(line, "^%s*@") or string.find(line, "^%s*$") do
    line = vim.api.nvim_buf_get_lines(0, idx - 1, idx, true)[1]
    idx = idx + 1
  end
  local icon = "▼"
  if vim.g.nerd_font then
    icon = " "
  end
  local padding = string.rep(" ", string.find(line, "[^%s]") - 1)
  return string.format("%s%s %s   %d", padding, icon, line, vim.v.foldend - vim.v.foldstart + 1)
end

vim.o.foldtext = [[v:lua.foldtext()")]]

return M
