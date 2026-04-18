vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "CopilotChat.nvim" and (kind == "install" or kind == "update") then
            vim.system({ "make", "tiktoken" }, { cwd = ev.data.path })
        end
    end,
})

vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/CopilotC-Nvim/CopilotChat.nvim",
}, { confirm = false })
