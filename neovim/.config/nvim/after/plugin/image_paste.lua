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
    if vim.tbl_contains(targets, "image/png") then
        return { "image/png", "png" }
    else
        return { targets[1], vim.split(targets[1], "/")[2] }
    end
end

local function save_image(folder, target, filename, extension)
    filename = vim.fs.basename(filename) or ""
    if filename == "" then
        return nil
    end
    extension = (extension or ""):gsub("[^%w_+%-]", "")
    if extension == "" then
        return nil
    end
    local image = ("%s.%s"):format(filename, extension)
    local path = Path:new(folder)
    path:mkdir { parents = true }
    path = path:joinpath(image)
    local i = 1
    while path:exists() do
        path = path:parent():joinpath(("%s_%d.%s"):format(filename, i, extension))
        i = i + 1
    end
    local ok, result = pcall(function()
        return vim.system({ "xclip", "-selection", "clipboard", "-t", target, "-o" }):wait()
    end)
    if not ok then
        vim.notify(tostring(result), vim.log.levels.ERROR)
        return nil
    end
    if result.code ~= 0 then
        vim.notify(result.stderr ~= "" and result.stderr or "xclip failed", vim.log.levels.ERROR)
        return nil
    end
    if vim.fn.writefile(result.stdout, tostring(path), "b") ~= 0 then
        return nil
    end
    return path
end

local function image_paste(func)
    local ok, targets = pcall(get_targets)
    if not ok or #targets == 0 then
        return false
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
        if not path then
            return
        end
        path = path:make_relative()
        if func then
            func(path)
        end
    end)
    return true
end

local function image_paste_tex()
    local buffer = vim.api.nvim_get_current_buf()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local function func(path)
        if not vim.api.nvim_buf_is_loaded(buffer) then
            vim.notify("Image saved, but the original buffer is no longer loaded", vim.log.levels.WARN)
            return
        end
        vim.api.nvim_buf_set_lines(buffer, row, row, false, {
            "\\begin{figure}[h]",
            "    \\centering",
            "    \\includegraphics[]{" .. path .. "}",
            "\\end{figure}",
        })
    end
    return image_paste(func)
end

vim.paste = (function(overridden)
    local pasting_image = false
    return function(lines, phase)
        if phase == -1 or phase == 1 then
            pasting_image = vim.bo.filetype == "tex" and vim.fn.getreg "+" == "" and image_paste_tex()
        end
        if pasting_image then
            return true
        end
        return overridden(lines, phase)
    end
end)(vim.paste)
