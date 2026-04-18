local f = vim.fn.stdpath "config" .. "/nvim-pack-lock.json"
local t = vim.json.decode(table.concat(vim.fn.readfile(f), "\n"))

local dirs = {}
for _, p in ipairs(vim.opt.packpath:get()) do
    vim.list_extend(dirs, vim.fn.glob(p .. "/pack/*/{start,opt}", true, true))
end

local function exists(name)
    for _, d in ipairs(dirs) do
        if vim.loop.fs_stat(d .. "/" .. name) then
            return true
        end
    end
end

for k in pairs(t.plugins) do
    if not exists(k) then
        t.plugins[k] = nil
    end
end

vim.fn.writefile({ vim.json.encode(t) }, f)
