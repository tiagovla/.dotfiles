local windline = require "windline"

local b_components = require "windline.components.basic"

local helper = require "windline.helpers"
local sep = helper.separators

local lsp_comps = require "windline.components.lsp"
local git_comps = require "windline.components.git"

local state = _G.WindLine.state

local hl_list = {
    Black = { "TokyoDarkGray", "TokyoDarkBg" },
    Inactive = { "TokyoDarkFg", "TokyoDarkBg" },
    Active = { "TokyoDarkGray", "TokyoDarkBg" },
}
local basic = {}

basic.divider = { b_components.divider, "" }
basic.space = { " ", "" }
basic.line_col = { b_components.line_col, hl_list.Inactive }
basic.file_name_inactive = { b_components.full_file_name, hl_list.Inactive }
basic.line_col_inactive = { b_components.line_col, hl_list.Inactive }

basic.vi_mode = {
    name = "vi_mode",
    hl_colors = {
        Normal = { "TokyoDarkBg", "TokyoDarkGreen" },
        Insert = { "TokyoDarkBg", "TokyoDarkBlue" },
        Visual = { "TokyoDarkBg", "TokyoDarkRed" },
        Replace = { "TokyoDarkBg", "TokyoDarkPurple" },
        Command = { "TokyoDarkBg", "TokyoDarkYellow" },
    },
    text = function()
        return " " .. state.mode[1] .. " "
    end,
    hl = function()
        return state.mode[2]
    end,
}

basic.vi_mode_sep = {
    name = "vi_mode_sep",
    hl_colors = {
        Normal = { "TokyoDarkGreen", "TokyoDarkBg" },
        Insert = { "TokyoDarkBlue", "TokyoDarkBg" },
        Visual = { "TokyoDarkRed", "TokyoDarkBg" },
        Replace = { "TokyoDarkPurple", "TokyoDarkBg" },
        Command = { "TokyoDarkYellow", "TokyoDarkBg" },
    },
    text = function()
        return ""
    end,
    hl = function()
        return state.mode[2]
    end,
}

basic.file_name = {
    text = function()
        local name = vim.fn.expand "%:p:t"
        if name == "" then
            name = "[No Name]"
        end
        return name .. " "
    end,
    hl_colors = { "TokyoDarkGray", "TokyoDarkBg" },
}

basic.explorer_name = {
    name = "NvimTree",
    text = function(bufnr)
        if bufnr == nil then
            return ""
        end
        local bufname = vim.fn.expand(vim.fn.bufname(bufnr))
        local _, _, bufnamemin = string.find(bufname, [[%/([^%/]*%/[^%/]*);%$$]])
        if bufnamemin ~= nil and #bufnamemin > 1 then
            return bufnamemin
        end
        return bufname
    end,
    hl_colors = { "TokyoDarkGray", "TokyoDarkBg" },
}

local explorer = {
    filetypes = { "NvimTree" },
    active = {
        { "  ", { "TokyoDarkGray", "TokyoDarkBg" } },

        basic.divider,
        basic.explorer_name,
    },
    always_active = true,
}

basic.lsp_diagnos = {
    name = "diagnostic",
    text = function(bufnr, winid, width)
        if lsp_comps.check_lsp() then
            return {
                { "   ", "Normal" },
                { lsp_comps.lsp_name(), "Normal" },
                { "   ", "Normal" },
            }
        end
        return ""
    end,
}

basic.git = {
    name = "git",
    hl_colors = {
        green = { "TokyoDarkGreen", "TokyoDarkBg" },
        red = { "TokyoDarkRed", "TokyoDarkBg" },
        blue = { "TokyoDarkBlue", "TokyoDarkBg" },
    },
    width = 10,
    text = function(bufnr)
        if git_comps.is_git(bufnr) then
            return {
                { git_comps.diff_added { format = " +%s", show_zero = false }, "green" },
                { git_comps.diff_removed { format = " -%s", show_zero = false }, "red" },
                { git_comps.diff_changed { format = " ~%s", show_zero = false }, "blue" },
            }
        end
        return ""
    end,
}
local git_branch = { git_comps.git_branch(), { "TokyoDarkGray", "TokyoDarkBg" }, 100 }
local default = {
    filetypes = { "default" },
    active = {
        basic.vi_mode,
        basic.vi_mode_sep,
        git_branch,

        basic.divider,
        basic.file_name,
        basic.divider,

        basic.git,
        basic.lsp_diagnos,
        -- basic.line_col,
    },
    inactive = {
        basic.file_name_inactive,
        basic.divider,
    },
}

windline.setup {
    colors_name = function(colors)
        colors.TokyoDarkBg = "#11121D"
        colors.TokyoDarkFg = "#45486A"
        colors.TokyoDarkRed = "#EE6D85"
        colors.TokyoDarkGreen = "#95C561"
        colors.TokyoDarkYellow = "#D7A65F"
        colors.TokyoDarkBlue = "#7199EE"
        colors.TokyoDarkPurple = "#9175C3"
        colors.TokyoDarkCyan = "#41B1A6"
        colors.TokyoDarkGray = "#A3A7C7"

        return colors
    end,
    statuslines = {
        default,
        explorer,
    },
}

-- run <leader>x to update color

vim.api.nvim_set_keymap("n", "<Space>x", ":luafile %<cr>", {})
