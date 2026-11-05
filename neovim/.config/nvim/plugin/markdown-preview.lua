local function install_dependencies(path, force)
    local app = path .. "/app"
    if not force
        and vim.fn.isdirectory(app .. "/node_modules/tslib") == 1
        and vim.fn.isdirectory(app .. "/node_modules/msgpack-lite") == 1
    then
        return
    end

    local result = vim.system({
        "npm",
        "install",
        "--no-save",
        "--package-lock=false",
        "@chemzqm/neovim@5.7.9",
        "msgpack-lite@0.1.26",
    }, { cwd = app }):wait()
    if result.code ~= 0 then
        vim.notify(result.stderr, vim.log.levels.ERROR)
    end
end

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "markdown-preview.nvim" and (kind == "install" or kind == "update") then
            install_dependencies(ev.data.path, true)
        end
    end,
})

vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" }, { confirm = false })

local plugin = vim.pack.get({ "markdown-preview.nvim" })[1]
if plugin then
    install_dependencies(plugin.path)
end

vim.g.mkdp_filetypes = { "markdown" }
