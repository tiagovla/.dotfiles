local counter = {}
local counter_mt = { __index = counter }

function counter:new()
    local timer = vim.loop.new_timer()
    local history = {}
    for index = 1, 60 do
        history[index] = 0
    end
    local state = { _accumulative = 0, history = history, timer = timer }
    return setmetatable(state, counter_mt)
end

function counter:register()
    for index = 59, 1, -1 do
        self.history[index + 1] = self.history[index]
    end
    self.history[1] = self._accumulative
    self._accumulative = 0
end

function counter:tick(value)
    if value == nil then
        self._accumulative = self._accumulative + 1
    else
        self._accumulative = value
    end
end

function counter:get_history(limit)
    local result = {}
    for index = 1, limit do
        result[index] = self.history[index]
    end
    return result
end

function counter:get_average(limit)
    local last = self:get_history(limit)
    local sum = 0
    for _, v in ipairs(last) do
        sum = sum + v
    end
    return sum * 60 / limit
end

function counter:start()
    self.timer:start(
        0,
        1000,
        vim.schedule_wrap(function()
            self:register()
        end)
    )
end

function counter:stop()
    self.timer:stop()
end

function counter:close()
    self.timer:close()
end

-- local actions = counter:new()
-- local edits = counter:new()
-- actions:start()
-- edits:start()
--
-- local ns = vim.api.nvim_create_namespace "apm"
-- vim.on_key(function()
--     actions:tick()
-- end, ns)
--
-- local augroup = vim.api.nvim_create_augroup("APM", {})
-- vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP" }, {
--     group = augroup,
--     callback = function()
--         edits:tick()
--     end,
-- })

-- local timer = vim.loop.new_timer()
-- timer:start(
--     0,
--     500,
--     vim.schedule_wrap(function()
--         local apm = "APM: " .. actions:get_average(2) .. " [" .. actions:get_average(60) .. "]"
--         local epm = "EPM: " .. edits:get_average(2) .. " [" .. edits:get_average(60) .. "]"
--         vim.pretty_print(apm .. " " .. epm)
--     end)
-- )
--
-- vim.defer_fn(function()
--     actions:stop()
--     actions:close()
--     edits:stop()
--     edits:close()
--     timer:stop()
--     timer:close()
-- end, 20000)
