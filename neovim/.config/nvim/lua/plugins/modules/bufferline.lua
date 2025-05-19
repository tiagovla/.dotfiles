local function get_harpoon_mark_from_id(id)
    local harpoon = require "harpoon"
    local Path = require "plenary.path"
    local list = harpoon:list()

    local buf_name = vim.api.nvim_buf_get_name(id)
    local root_dir = list.config.get_root_dir()
    local n_path = Path:new(buf_name):make_relative(root_dir)
    local _, idx = list:get_by_value(n_path)
    return idx
end

return {
    "akinsho/nvim-bufferline.lua",
    lazy = false,
    init = function()
        vim.keymap.set("n", "<c-n>", "<cmd>BufferLineCycleNext<cr>")
        vim.keymap.set("n", "<c-p>", "<cmd>BufferLineCyclePrev<cr>")
    end,
    opts = {
        options = {
            view = "multiwindow",
            numbers = function(opts)
                return get_harpoon_mark_from_id(opts.id)
            end,
            modified_icon = "●",
            max_prefix_length = 5,
            tab_size = 18,
            diagnostics = "nvim_lsp",
            separator_style = { "|", "" },
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    text_align = "center",
                },
            },
            sort_by = function(buffer_a, buffer_b)
                local function get_local_mark(id)
                    return get_harpoon_mark_from_id(id) or 999999
                end
                return get_local_mark(buffer_a.id) < get_local_mark(buffer_b.id)
            end,
        },
    },
}
