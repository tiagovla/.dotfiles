local ok, _ = pcall(require, "plenary")
if not ok then
    return
end

local Job = require "plenary.job"
local Path = require "plenary.path"

local get_targets = function()
    local j = Job:new {
        command = "xclip",
        args = { "-selection", "clipboard", "-t", "TARGETS", "-o" },
    }
    return vim.tbl_filter(function(x)
        return string.match(x, "^image/")
    end, j:sync())
end

local function get_info(targets)
    if not vim.tbl_contains(targets, "image/png") then
        return { "image/png", "png" }
    else
        return { targets[1], vim.split(targets[1], "/")[2] }
    end
end

local function save_image(folder, target, filename, extension)
    local image = ("%s.%s"):format(filename, extension)
    local path = Path:new(folder)
    path:mkdir { parents = true }
    path = path:joinpath(image)
    local i = 1
    while path:exists() do
        path = path:parent():joinpath(("%s_%d.%s"):format(filename, i, extension))
        i = i + 1
    end
    local cmd = [[xclip -selection clipboard -t %s -o > %s]]
    vim.fn.system(cmd:format(target, path))
    return path
end

local function image_paste(func)
    local targets = get_targets()
    if #targets == 0 then
        return true
    end
    local target, extension = unpack(get_info(targets))
    local prompt_opts = {
        prompt = "Image name: ",
        default = "image",
    }
    vim.ui.input(prompt_opts, function(filename)
        if not filename or #filename == 0 then
            return
        end
        local path = save_image("images", target, filename, extension)
        path = path:make_relative()
        if func then
            func(path)
        end
    end)
end

local function image_paste_tex()
    local function func(path)
        local cursor = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_buf_set_lines(0, cursor[1] - 1, cursor[1], false, {
            "\\begin{figure}[h]",
            "    \\centering",
            "    \\includegraphics[]{" .. path .. "}",
            "\\end{figure}",
        })
    end
    image_paste(func)
end

vim.paste = (function(overridden)
    return function(lines, phase)
        local reg = vim.fn.getreg "+"
        if reg == "" and vim.bo[0].ft == "tex" then
            image_paste_tex()
        else
            overridden(lines, phase)
        end
    end
end)(vim.paste)
