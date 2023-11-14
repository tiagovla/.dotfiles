local Watcher = setmetatable({}, {
    __call = function(cls, ...)
        return cls:new(...)
    end,
})

function Watcher:new(fname, callback)
    local fullpath = vim.api.nvim_call_function("fnamemodify", { fname, ":p" })
    local state = { event = vim.uv.new_fs_event(), fname = fullpath, callback = callback }
    return setmetatable(state, {
        __index = Watcher,
    })
end

function Watcher:on_change(err, fname, status)
    self.callback(self.event)
    self.event:stop()
    self:watch_file(fname)
end

function Watcher:watch_file(fname)
    if not vim.fs.find(fname) then
        vim.notify "No file found to be watched!"
        return
    end
    self.event:start(
        fname,
        {},
        vim.schedule_wrap(function(...)
            self:on_change(...)
        end)
    )
end

function Watcher:start()
    self:watch_file(self.fname)
end

function Watcher:stop()
    self.event:stop()
end

return Watcher
