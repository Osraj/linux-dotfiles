-- moving lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {})

-- when appending below line keep the the curser where it is don't move it to the end
vim.keymap.set("n", "J", "mzJ`z", {})

-- when using pg-up and pg-dn center the page
vim.keymap.set("n", "<C-d>", "<C-d>zz", {})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {})
-- when using next and prev search term center the page
vim.keymap.set("n", "n", "nzzzv", {})
vim.keymap.set("n", "N", "Nzzzv", {})

-- yanking to the system clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("v", "<leader>y", '"+y')

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-c>", "<Esc>")
vim.keymap.set("v", "<C-c>", "<Esc>")
-- good to unbind some useless stuff
vim.keymap.set("n", "Q", "<nop>")

-- indent and unindent without losing the visual select
vim.keymap.set("n", ">", ">>", {})
vim.keymap.set("v", ">", "> gv", {})
vim.keymap.set("n", "<", "<<", {})
vim.keymap.set("v", "<", "< gv", {})

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-c>', '<cmd>nohlsearch<CR>')

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
