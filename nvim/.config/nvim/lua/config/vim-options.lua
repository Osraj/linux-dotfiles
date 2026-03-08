-- put this option to false if you don't have a nerd font
vim.g.have_nerd_font = true
vim.opt.swapfile = false
vim.opt.guicursor = {"n-v-c-i:block"}

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.incsearch = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

vim.opt.updatetime = 50

vim.opt.termguicolors = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "



-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = {
    tab = '» ', -- Highlight tabs
    trail = '·', -- Highlight trailing spaces
    nbsp = '␣', -- Highlight non-breaking spaces
    lead = '·', -- Highlight leading spaces
}

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'


-- Show which line your cursor is on
vim.opt.cursorline = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true
