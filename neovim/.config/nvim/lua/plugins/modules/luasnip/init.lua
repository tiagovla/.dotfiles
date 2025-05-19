local M = { "L3MON4D3/LuaSnip", version = "v2.*", lazy = false, dependencies = { { "rafamadriz/friendly-snippets" } } }

function M.init()
    vim.keymap.set("i", "<c-u>", function()
        require "luasnip.extras.select_choice"()
    end)
    local function reload_luasnip_config()
        require("luasnip").cleanup()
        for k in pairs(package.loaded) do
            if k:match ".*luasnip.snips.*" then
                package.loaded[k] = nil
                require(k)
            end
        end
    end
    vim.keymap.set("n", "<space>rs", function()
        reload_luasnip_config()
    end, { desc = "Reload snippets" })
end

function M.config()
    local ls_types = require "luasnip.util.types"
    local util = require "luasnip.util.util"

    require("luasnip/loaders/from_vscode").lazy_load {}

    require("luasnip.config").setup {
        history = true,
        region_check_events = "CursorMoved",
        delete_check_events = "TextChangedI",
        updateevents = "TextChanged,TextChangedI,InsertLeave",
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
        ext_opts = {
            [ls_types.choiceNode] = {
                active = {
                    virt_text = { { " ", "Keyword" } },
                },
            },
            [ls_types.insertNode] = {
                active = {
                    virt_text = { { "●", "Special" } },
                },
            },
        },
        parser_nested_assembler = function(_, snippet)
            local select = function(snip, no_move)
                snip.parent:enter_node(snip.indx)
                for _, node in ipairs(snip.nodes) do
                    node:set_mark_rgrav(true, true)
                end
                if not no_move then
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                    local pos_begin, pos_end = snip.mark:pos_begin_end()
                    util.normal_move_on(pos_begin)
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v", true, false, true), "n", true)
                    util.normal_move_before(pos_end)
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("o<C-G>", true, false, true), "n", true)
                end
            end

            function snippet:jump_into(dir, no_move)
                if self.active then
                    if dir == 1 then
                        self:input_leave()
                        return self.next:jump_into(dir, no_move)
                    else
                        select(self, no_move)
                        return self
                    end
                else
                    self:input_enter()
                    if dir == 1 then
                        select(self, no_move)
                        return self
                    else
                        return self.inner_last:jump_into(dir, no_move)
                    end
                end
            end

            function snippet:jump_from(dir, no_move)
                if dir == 1 then
                    return self.inner_first:jump_into(dir, no_move)
                else
                    self:input_leave()
                    return self.prev:jump_into(dir, no_move)
                end
            end

            return snippet
        end,
    }
    require "plugins.modules.luasnip.snips.cmake"
    require "plugins.modules.luasnip.snips.cpp"
    require "plugins.modules.luasnip.snips.lua"
    require "plugins.modules.luasnip.snips.python"
    require "plugins.modules.luasnip.snips.tex"
    require "plugins.modules.luasnip.snips.tex_math"
end

return M
