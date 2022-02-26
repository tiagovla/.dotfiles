require "plugins.config.scope"
return {
    config = function()
        require("bufferline").setup {
            options = {
                view = "multiwindow",
                numbers = "ordinal",
                modified_icon = "●",
                tab_size = 18,
                diagnostics = "nvim_lsp",
                separator_style = { "|", "" },
                custom_filter = function(buf_number, buf_numbers)
                    local list = require("plugins.config.scope").show_bufs()
                    if vim.tbl_contains(list, buf_number) then
                        return true
                    end
                end,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "center",
                    },
                },
            },
        }
    end,
}
