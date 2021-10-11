local utils = require("utils.functions")

local function load_plugins(use)
    -- Packer
    -- use {"wbthomason/packer.nvim", opt = true}
    use({"$HOME/github/packer.nvim", opt = true})
    use({"sonph/onehalf", rtp = "vim"})

    -- Themes
    use("tiagovla/ezmap.nvim")

    -- theme
    -- use({ "tiagovla/tokyodark.nvim" })
    use({"$HOME/github/tokyodark.nvim"})

    use({"akinsho/nvim-bufferline.lua", require("plug-config.bufferline")})
    use({"hoob3rt/lualine.nvim", require("plug-config.lualine")})

    -- FZF
    use({"nvim-telescope/telescope.nvim", require("plug-config.telescope")})

    use({
        "ahmedkhalf/project.nvim",
        config = function() require("project_nvim").setup({}) end
    })
    use({"akinsho/toggleterm.nvim", require("plug-config.toggleterm")})

    -- Formatting
    use({"norcalli/nvim-colorizer.lua", require("plug-config.colorizer")})
    use({"tpope/vim-commentary", event = "BufRead"})
    use({"tpope/vim-surround", event = "BufRead"})

    -- LSP + Git
    use({"onsails/lspkind-nvim", require("plug-config.lspkind")})
    use({"hrsh7th/nvim-cmp", require("plug-config.cmp")})

    use({"$HOME/github/lspconfigplus", require("plug-config.lsp")})
    use({"ray-x/lsp_signature.nvim"})

    use({"lewis6991/gitsigns.nvim", require("plug-config.gitsigns")})
    use({"sindrets/diffview.nvim", require("plug-config.diffview")})

    -- Debug
    use({"mfussenegger/nvim-dap", require("plug-config.dap")})

    -- Syntax
    use({"nvim-treesitter/nvim-treesitter", require("plug-config.treesitter")})
    -- use 'nvim-treesitter/playground'

    use({"kyazdani42/nvim-tree.lua", require("plug-config.nvimtree")})

    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end
    })
    use({
        "glacambre/firenvim",
        run = function() vim.fn["firenvim#install"](0) end
    })

    -- General Tools
    -- use {"tweekmonster/startuptime.vim", cmd = {"StartupTime"}}
    use({"liuchengxu/vim-which-key", require("plug-config.whichkey")})
    use({"sirver/UltiSnips", require("plug-config.ultisnips")})

    -- Latex
    use({"iamcco/markdown-preview.nvim", ft = "markdown"})
    use({"tiagovla/tex-conceal.vim", ft = "tex"})
    use({"christoomey/vim-tmux-navigator"})
    use({
        "kkoomen/vim-doge",
        config = function() vim.g.doge_doc_standard_python = "numpy" end
    })
end

local install = utils.ensure_packer_installed()
local packer = require("packer")
packer.startup(function() load_plugins(utils.packer_use) end)
if install then
    -- TODO: call this synchronously
    -- packer.install()
    -- packer.compile()
end
