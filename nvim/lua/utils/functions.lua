local U = {}

function U.map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function U.ensure_packer_installed()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
    local install = false

    if fn.empty(fn.glob(install_path)) > 0 then
        print("Installing Packer")
        fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
        install = true
    end

    vim.api.nvim_command("packadd packer.nvim")
    return install
end

U.packer_use = function(list)
    local packer = require("packer")
    if vim.tbl_islist(list) and #list > 1 then
        packer.use(vim.tbl_extend("force", {list[1]}, list[2]))
    else
        packer.use(list)
    end
end

return U
