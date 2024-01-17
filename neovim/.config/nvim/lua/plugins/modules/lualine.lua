local M = { "nvim-lualine/lualine.nvim", lazy = false }

function M.config()
    local theme = require "lualine.themes.tokyodark"
    local ok, p = pcall(require, "tokyodark.palette")
    if not ok then
        return
    end
    local colors = {
        diff_add = "#9ECE6A",
        diff_modify = "#7AA2F7",
        diff_remove = "#F7768E",
        border = p.bg5,
    }

    for _, session in pairs(theme.inactive) do
        session.gui = "underline"
        session.fg = colors.border
    end

    local custom_components = {
        pwd = function()
            return vim.fn.fnamemodify(vim.fn.getcwd(0, 0), ":~")
        end,
    }

    local default_config = {
        options = {
            theme = theme,
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
            icons_enabled = true,
            globalstatus = true,
        },
        sections = {
            lualine_a = { { "mode", upper = true } },
            lualine_b = {
                { "branch", icon = "" },
                {
                    require("noice").api.status.mode.get,
                    cond = require("noice").api.status.mode.has,
                    color = { fg = "#ff9e64" },
                },
            },
            lualine_c = { custom_components.pwd },
            lualine_x = { "filetype" },
            lualine_y = {
                {
                    "diff",
                    colored = true,
                    diff_color = {
                        added = { fg = colors.diff_add },
                        modified = { fg = colors.diff_modify },
                        removed = { fg = colors.diff_remove },
                    },
                    symbols = { added = "+", modified = "~", removed = "-" },
                },
                {
                    require("noice").api.status.search.get,
                    cond = require("noice").api.status.search.has,
                    color = { fg = "#ff9e64" },
                },
                "location",
            },
            lualine_z = {},
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        extensions = { { sections = { lualine_b = { "filetype" } }, filetypes = { "NvimTree" } } },
    }

    require("lualine").setup(default_config)
end

return M
