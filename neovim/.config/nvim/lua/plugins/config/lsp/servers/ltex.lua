local lspconfig = require "lspconfig"
local util = require "lspconfig.util"
local handlers = require "vim.lsp.handlers"

local filename = "ltex_config.json"

local function load_config()
    local file = io.open(filename, "r")
    if file then
        local config = vim.json.decode(file:read "a")
        file:close()
        return config
    end
    return { dictionary = {}, disabledRules = {}, hiddenFalsePositives = {} }
end

local function update_config()
    local ltex = util.get_active_client_by_name(0, "ltex")
    local config = load_config()
    if ltex then
        ltex.config.settings.ltex = config
        ltex.request("workspace/didChangeConfiguration", ltex.config.settings, function(err, result) end)
    end
end

local function add_to_config(type, lang, value)
    local config = load_config()
    local key = config[type][lang]
    if key then
        if not vim.tbl_contains(key, value) then
            table.insert(key, value)
        end
    else
        config[type][lang] = { value }
    end

    local file = io.open(filename, "w")
    if file then
        file:write(vim.json.encode(config))
        file:close()
    end
    update_config()
end

local function populate_config(type, data)
    for k, vv in pairs(data) do
        for _, v in pairs(vv) do
            add_to_config(type, k, v)
        end
    end
end

local function on_workspace_executecommand(err, content, ctx)
    if ctx.params.command == "_ltex.addToDictionary" then
        local data = ctx.params.arguments[1].words
        populate_config("dictionary", data)
    elseif ctx.params.command == "_ltex.disableRules" then
        local data = ctx.params.arguments[1].ruleIds
        populate_config("disabledRules", data)
    elseif ctx.params.command == "_ltex.hideFalsePositives" then
        local data = ctx.params.arguments[1].falsePositives
        populate_config("hiddenFalsePositives", data)
    else
        handlers[ctx.method](err, content, ctx)
    end
end

lspconfig.ltex.setup {
    on_init = function(client)
        client.config.settings.ltex = load_config()
    end,
    handlers = {
        ["workspace/executeCommand"] = on_workspace_executecommand,
    },
}
