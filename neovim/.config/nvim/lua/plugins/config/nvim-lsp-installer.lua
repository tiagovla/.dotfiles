local function setup()
    vim.defer_fn(function()
        pcall(require("packer").loader, "nvim-lsp-installer")
        vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
    end, 0)
end

local function config()
    require("nvim-lsp-installer").setup {
        automatic_installation = true,
        ui = { border = "single" },
    }
end

return {
    setup = setup,
    config = config,
}
