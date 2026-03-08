vim.api.nvim_create_autocmd('FileType', {
    -- This handler will fire when the buffer's 'filetype' is "systemverilog" or "verilog"
    pattern = { 'verilog', 'systemverilog' },
    callback = function()
        vim.lsp.start({
            name = 'verible',
            cmd = { 'verible-verilog-ls', '--rules_config_search' },
        })
    end,
})

vim.lsp.config('verible', {
    filetypes = { 'verilog', 'systemverilog' },
})

-- Setting the filetype for Verilog
vim.api.nvim_create_autocmd(
    { "BufNewFile", "BufRead" }, {
        pattern = { "*.v" },
        command = "set filetype=verilog",
    }
)

-- Setting the filetype for SystemVerilog
vim.api.nvim_create_autocmd(
    { "BufNewFile", "BufRead" }, {
        pattern = { "*.sv" },
        command = "set filetype=systemverilog",
    }
)

vim.api.nvim_create_autocmd(
    { "FileType" }, {
        pattern = {"c","systemverilog", "verilog"} ,
        callback = function()
            -- Example: Set tab width for C
            vim.bo.expandtab = true
            vim.bo.tabstop = 2
            vim.bo.softtabstop = 2
            vim.bo.shiftwidth = 2
        end,

    }
)

