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

return packer
