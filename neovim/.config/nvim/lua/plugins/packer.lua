local cmd = vim.api.nvim_command
local fn = vim.fn

local function ensure_installed()
    local install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
    local install = false

    if fn.empty(fn.glob(install_path)) > 0 then
        print "Installing Packer..."
        fn.delete(vim.fn.stdpath "config" .. "/lua/packer_compiled.lua")
        fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
        install = true
    end

    cmd "packadd packer.nvim"
    return install
end

ensure_installed()

local ok, packer = pcall(require, "packer")

if not ok then
    error "Could not install packer"
end

packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "single" }
        end,
        prompt_border = "single",
    },
    git = {
        clone_timeout = 600,
    },
    auto_clean = true,
    compile_on_sync = true,
}

local load = function(path)
    require("plugins.config." .. path)
    local ok, res = pcall(require, "plugins.config." .. path)
    if ok then
        return res
    else
        vim.notify("Could not load " .. path)
        return {}
    end
end

local use = function(config)
    if config.ext then
        local config_ext = load(config.ext)
        config = vim.tbl_deep_extend("force", config, config_ext)
        config.ext = nil
    end
    packer.use(config)
end

-- hard coded local plugins path
local function use_local(config)
    local sp = vim.split(config[1], "/")
    local repo_path = vim.fn.expand "$HOME/github/" .. sp[#sp]
    if vim.fn.isdirectory(repo_path) == 1 then
        config[1] = repo_path
    else
        vim.notify("Could not load local " .. repo_path .. ", using online instead.")
    end
    use(config)
end

return { packer, use, use_local }
