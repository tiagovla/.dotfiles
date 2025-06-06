-- local function make()
--     local lines = { "" }
--     local winnr = vim.fn.win_getid()
--     local bufnr = vim.api.nvim_win_get_buf(winnr)
--
--     local makeprg = vim.api.nvim_get_option_value("makeprg", {})
--     local efm = vim.api.nvim_get_option_value("errorformat", {})
--
--     if not makeprg then
--         return
--     end
--
--     local cmd = vim.fn.expandcmd(makeprg)
--     vim.print("Running: " .. cmd)
--
--     local function on_event(job_id, data, event)
--         if event == "stdout" or event == "stderr" then
--             if data then
--                 vim.list_extend(lines, data)
--             end
--         end
--
--         if event == "exit" then
--             vim.fn.setqflist({}, " ", {
--                 title = cmd,
--                 lines = lines,
--                 efm = efm,
--             })
--             vim.api.nvim_command "doautocmd QuickFixCmdPost"
--             for i = #lines, 1, -1 do
--                 if lines[i] == "" then
--                     table.remove(lines, i)
--                 end
--             end
--             vim.print("Done: " .. cmd)
--         end
--     end
--
--     local job_id = vim.fn.jobstart(cmd, {
--         on_stderr = on_event,
--         on_stdout = on_event,
--         on_exit = on_event,
--         stdout_buffered = true,
--         stderr_buffered = true,
--     })
-- end
--
-- local terminal = require("toggleterm.terminal").Terminal
--
-- vim.api.nvim_create_user_command("Makee", function()
--     local lazygit = terminal:new {
--         -- cmd = "make",
--         dir = "/home/tiagovla/github/oiseau/",
--         hidden = true,
--         -- close_on_exit = false,
--         on_stdout = function()
--             print "out"
--         end,
--         on_stderr = function()
--             print "err"
--         end,
--         on_exit = function()
--             print "exit"
--         end,
--     }
--     lazygit:toggle()
--     lazygit:send "m"
-- end, {})
--
-- vim.api.nvim_create_user_command("Make", make, {})
