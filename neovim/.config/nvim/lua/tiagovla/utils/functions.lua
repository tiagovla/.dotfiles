U = {}

function U.ensure_packer_installed()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
    local install = false

    if fn.empty(fn.glob(install_path)) > 0 then
        print "Installing Packer"
        fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
        install = true
    end

    vim.api.nvim_command "packadd packer.nvim"
    return install
end

U.packer_use = function(list)
    local packer = require "packer"
    if vim.tbl_islist(list) and #list > 1 then
        packer.use(vim.tbl_extend("force", { list[1] }, list[2]))
    else
        packer.use(list)
    end
end

U.load_config = function(plug_config)
    status, res = pcall(require, "tiagovla.plug_config." .. plug_config)
    if status then
        return res
    else
        print(plug_config, res)
        return {}
    end
end

return U
