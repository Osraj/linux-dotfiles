return
{
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
        local oil = require("oil")
        oil.setup({
            default_file_explorer = true,
            delete_to_trash = true,
            vim_options = {
                show_hidden = true,
            },

            -- float = {
            --     -- Padding around the floating window
            --     padding = 2,
            --     -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            --     max_width = 0,
            --     max_height = 0,
            --     border = "rounded",
            --     win_options = {
            --         winblend = 0,
            --     },
            -- },
            --
            -- confirmation = {
            --     -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            --     -- min_width and max_width can be a single value or a list of mixed integer/float types.
            --     -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
            --     -- max_width = 0.6,
            --     -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
            --     -- min_width = { 40, 0.4 },
            --     -- optionally define an integer/float for the exact width of the preview window
            --     width = 0.2,
            --     -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            --     -- min_height and max_height can be a single value or a list of mixed integer/float types.
            --     -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
            --     -- max_height = 0.4,
            --     -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
            --     -- min_height = { 5, 0.1 },
            --     -- optionally define an integer/float for the exact height of the preview window
            --     height = 0.2,
            --     border = "rounded",
            --     win_options = {
            --         winblend = 0,
            --     },
            -- },

            skip_confirm_for_simple_edits = true,
        })
    end
}

--
-- }
--     {
--     "nvim-neo-tree/neo-tree.nvim",
--     branch = "v3.x",
--     dependencies = {
--         "nvim-lua/plenary.nvim",
--         "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
--         "MunifTanjim/nui.nvim",
--         -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
--     },
--     config = function()
--         require('neo-tree').setup {
--             filesystem = {
--                 filtered_items = {
--                     visible = true, -- shows files that are hidden e.g dotfiles and gitignored files
--                 }
--             }
--         }
--         vim.cmd("Neotree close")
--     end,
-- }
