U = {}

U.load_cfg = function(plug_config)
    local path = "tiagovla.plug_config." .. plug_config
    status, res = pcall(require, path)
    if status then
        return res
    else
        print(plug_config, res)
        return {}
    end
end

U.packer_use = function(list)
    local packer = require "packer"
    if vim.tbl_islist(list) and #list > 1 then
        packer.use(vim.tbl_extend("force", { list[1] }, list[2]))
    else
        packer.use(list)
    end
end

U.prepare_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
    local install = false

    if fn.empty(fn.glob(install_path)) > 0 then
        print "Installing Packer"
        fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
        install = true
        vim.fn.delete(vim.fn.expand "$HOME/.config/nvim/plugin/packer_compiled.lua")
    end

    vim.api.nvim_command "packadd packer.nvim"
    return not install
end

return U
