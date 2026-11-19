local config = {
    width = 120,
}

local function centered_right_width(edge)
    return edge - math.floor((vim.o.columns + config.width) / 2) - 1
end

local function fit(available, edge)
    local min_pad = math.max(1, vim.o.winminwidth)
    local code = math.min(config.width, available - min_pad)
    if code < min_pad then
        return
    end
    local padding = available - code
    local right = math.min(math.max(min_pad, centered_right_width(edge)), padding)
    local left = padding - right - 1
    if left < min_pad then
        return code, padding, 0
    end
    return code, right, left
end

local function create_pad(content, side, size)
    local buffer = vim.api.nvim_create_buf(false, true)
    vim.bo[buffer].bufhidden = "wipe"
    vim.bo[buffer].modifiable = false

    local win = vim.api.nvim_open_win(buffer, false, {
        win = content,
        split = side,
        width = size,
        noautocmd = true,
    })
    local options = vim.wo[win]
    options.number = false
    options.relativenumber = false
    options.cursorline = false
    options.cursorcolumn = false
    options.signcolumn = "no"
    options.foldcolumn = "0"
    options.colorcolumn = ""
    options.list = false
    options.statuscolumn = ""
    options.statusline = " "
    options.winfixbuf = true
    options.winfixwidth = side == "right"
    return win
end

local function close_pads(layout)
    vim.t.neck_layout = nil
    if vim.api.nvim_win_is_valid(layout.content) then
        vim.wo[layout.content].winfixwidth = layout.winfixwidth
    end
    for _, win in ipairs { layout.right, layout.left } do
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, false)
        end
    end
end

local function remove_left_pad(layout)
    local splitright = vim.o.splitright
    local fixed = vim.wo[layout.content].winfixwidth
    vim.o.splitright = false
    vim.wo[layout.content].winfixwidth = false
    local ok, err = pcall(vim.api.nvim_win_close, layout.left, false)
    vim.wo[layout.content].winfixwidth = fixed
    vim.o.splitright = splitright
    if not ok then
        error(err)
    end
    layout.left = nil
    vim.t.neck_layout = layout
end

local function toggle()
    local layout = vim.t.neck_layout
    if layout then
        close_pads(layout)
        return
    end

    local content = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_config(content).relative ~= "" or vim.bo.buftype ~= "" then
        return
    end
    local available = vim.api.nvim_win_get_width(content)
    local edge = vim.api.nvim_win_get_position(content)[2] + available
    local code_width, right_width, left_width = fit(available - 1, edge)
    if code_width ~= config.width then
        return
    end

    local original_winfixwidth = vim.wo[content].winfixwidth
    vim.wo[content].winfixwidth = false
    local right = create_pad(content, "right", right_width)
    local left = left_width > 0 and create_pad(content, "left", left_width) or nil
    vim.wo[content].winfixwidth = true
    vim.t.neck_layout = {
        content = content,
        left = left,
        right = right,
        winfixwidth = original_winfixwidth,
    }
end

local function align(layout)
    local content, left, right = layout.content, layout.left, layout.right
    if
        not vim.api.nvim_win_is_valid(content)
        or (left and not vim.api.nvim_win_is_valid(left))
        or not vim.api.nvim_win_is_valid(right)
    then
        return
    end

    local content_width = vim.api.nvim_win_get_width(content)
    local right_width = vim.api.nvim_win_get_width(right)
    local content_col = vim.api.nvim_win_get_position(content)[2]
    local right_col = vim.api.nvim_win_get_position(right)[2]
    local left_width = left and vim.api.nvim_win_get_width(left) or 0
    local start = left and vim.api.nvim_win_get_position(left)[2] or content_col
    if (left and start + left_width + 1 ~= content_col) or content_col + content_width + 1 ~= right_col then
        return
    end

    local edge = right_col + right_width
    local code_width, target_right, target_left = fit(edge - start - 1, edge)
    if not code_width then
        return
    end

    if left and target_left == 0 then
        remove_left_pad(layout)
        left = nil
        right_width = vim.api.nvim_win_get_width(right)
    end

    local left_shift = target_left - left_width
    local right_shift = right_width - target_right

    if left and left_shift < 0 then
        vim.fn.win_move_separator(left, left_shift)
    end
    if right_shift ~= 0 then
        vim.fn.win_move_separator(content, right_shift)
    end
    if left and left_shift > 0 then
        vim.fn.win_move_separator(left, left_shift)
    elseif not left and target_left > 0 then
        local fixed = vim.wo[content].winfixwidth
        vim.wo[content].winfixwidth = false
        layout.left = create_pad(content, "left", target_left)
        vim.wo[content].winfixwidth = fixed
        vim.t.neck_layout = layout
    end
end

local function schedule_align()
    if not vim.t.neck_layout then
        return
    end
    local tab = vim.api.nvim_get_current_tabpage()
    vim.schedule(function()
        if vim.api.nvim_get_current_tabpage() ~= tab then
            return
        end
        local layout = vim.t.neck_layout
        if layout then
            align(layout)
        end
    end)
end

local group = vim.api.nvim_create_augroup("LocalNoNeckPain", { clear = true })

vim.api.nvim_create_user_command("NoNeckPain", toggle, { desc = "Toggle centered editing" })
vim.keymap.set("n", "<leader>zz", "<cmd>NoNeckPain<cr>", { desc = "Toggle centered editing" })
vim.api.nvim_create_autocmd("VimEnter", { group = group, once = true, callback = toggle })
vim.api.nvim_create_autocmd({ "VimResized", "TabEnter" }, { group = group, callback = schedule_align })

vim.api.nvim_create_autocmd("WinEnter", {
    group = group,
    callback = function()
        local layout = vim.t.neck_layout
        local win = vim.api.nvim_get_current_win()
        if not layout or (win ~= layout.left and win ~= layout.right) then
            return
        end

        local number = vim.api.nvim_win_get_number(win)
        local step = vim.fn.winnr "#" < number and 1 or -1
        local wins = vim.api.nvim_tabpage_list_wins(0)
        for offset = 1, #wins - 1 do
            local index = (number - 1 + step * offset) % #wins + 1
            local target = wins[index]
            if
                target ~= layout.left
                and target ~= layout.right
                and vim.api.nvim_win_get_config(target).relative == ""
            then
                vim.api.nvim_set_current_win(target)
                return
            end
        end
    end,
})

vim.api.nvim_create_autocmd("QuitPre", {
    group = group,
    callback = function()
        local layout = vim.t.neck_layout
        if layout and vim.api.nvim_get_current_win() == layout.content then
            close_pads(layout)
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWinLeave" }, {
    group = group,
    callback = function(event)
        if vim.bo[event.buf].filetype == "NvimTree" then
            schedule_align()
        end
    end,
})

vim.api.nvim_create_autocmd("WinResized", {
    group = group,
    callback = function()
        if not vim.t.neck_layout then
            return
        end
        for _, win in ipairs(vim.v.event.windows) do
            if vim.api.nvim_win_is_valid(win) and vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "NvimTree" then
                schedule_align()
                return
            end
        end
    end,
})
