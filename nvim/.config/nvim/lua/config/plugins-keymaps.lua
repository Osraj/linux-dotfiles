local builtin = require("telescope.builtin")
vim.keymap.set({ "n", "v" }, "<leader>sf", builtin.find_files, {})
vim.keymap.set({ "n", "v" }, "<leader>sg", builtin.live_grep, {})

-- local Oil
local oil = require("oil")
vim.keymap.set({ "n", "v" }, "<C-e>", oil.open_float) --":Oil<CR>")
vim.keymap.set("n", "<leader>hd", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

vim.keymap.set("n", "<leader>p", vim.lsp.buf.format, {})

local cmp = require("cmp")
cmp.setup({
    mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ["<CR>"] = cmp.mapping(
            cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert, select = true,
            },
            { "i", "c" }
        ),
    },
})


oil.setup({
    keymaps = {
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = false,
        ["<C-c>"] = false,
        ["q"] = { "actions.close", mode = "n" },
    },
})

local ls = require("luasnip")


vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

-- noice plugin keymaps
vim.keymap.set({ "n", "v" }, "<leader>snh", function()
    require("noice").cmd("history")
end)
vim.keymap.set({ "n", "v" }, "<leader>sna", function()
    require("noice").cmd("all")
end, {})
vim.keymap.set({ "n", "v" }, "<leader>snd", function()
    require("noice").cmd("dismiss")
end, {})
vim.keymap.set({ "n", "v" }, "<leader>snt", function()
    require("noice").cmd("pick")
end, {})

-- to open diagnostic window
vim.keymap.set("n", "<leader>sdg",
    ":Telescope diagnostics <CR>",
    { noremap = true, silent = true })
vim.keymap.set("n", "<leader>sdf",
    ":Telescope diagnostics bufnr=0 <CR>"
    , { noremap = true, silent = true })
