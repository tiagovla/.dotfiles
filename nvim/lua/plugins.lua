local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
    execute "packadd packer.nvim"
end

vim.cmd [[packadd packer.nvim]]

require("packer").startup(function()
    -- Packer
    use {"wbthomason/packer.nvim", opt = true}

    -- theme
    use "$HOME/github/tokyodark.nvim"

    -- FZF
    use {
        "nvim-telescope/telescope.nvim",
        cmd = {"Telescope"},
        requires = {
            {"nvim-lua/popup.nvim", opt = true}, {"nvim-lua/plenary.nvim", opt = true},
            {"nvim-telescope/telescope-media-files.nvim", opt = true},
        },
        config = function()
            require("plug-config.telescope")
        end,
    }

    -- Formatting
    use {
        "norcalli/nvim-colorizer.lua",
        ft = {"html", "css", "sass", "vim", "lua", "javascript", "typescript"},
        config = function()
            require("plug-config.colorizer")
        end,
    }
    use {"tpope/vim-commentary", event = "BufRead"}
    use {"tpope/vim-surround", event = "BufRead"}

    -- LSP + Git
    use {
        "glepnir/lspsaga.nvim",
        cmd = "Lspsaga",
        config = function()
            require("plug-config.lspsaga")
        end,
    }
    use {
        "hrsh7th/nvim-compe",
        event = "InsertEnter",
        config = function()
            require("compe").setup {
                enabled = true,
                autocomplete = true,
                debug = false,
                min_length = 1,
                preselect = "enable",
                throttle_time = 80,
                source_timeout = 200,
                incomplete_delay = 400,
                max_abbr_width = 100,
                max_kind_width = 100,
                max_menu_width = 100,
                documentation = true,

                source = {
                    path = true,
                    buffer = true,
                    calc = true,
                    nvim_lsp = true,
                    nvim_lua = true,
                    -- ultisnips = true
                },
            }
        end,
    }

    use {
        "tiagovla/lspconfigplus",
        event = "BufReadPre",
        requires = {"neovim/nvim-lspconfig", opt = true},
        config = function()
            require("plug-config.lsp")
        end,
    }

    use {
        "lewis6991/gitsigns.nvim",
        requires = {"nvim-lua/plenary.nvim", opt = true},
        config = function()
            require("plug-config.gitsigns")
        end,
    }

    use {
        "sindrets/diffview.nvim",
        cmd = {"DiffviewOpen"},
        config = function()
            require("plug-config.diffview")
        end,
    }

    -- Syntax
    use {
        "nvim-treesitter/nvim-treesitter",
        -- run = ':TSUpdate',
        event = "BufRead",
        config = function()
            require("plug-config.treesitter")
        end,
    }
    -- use 'nvim-treesitter/playground'

    -- Theme
    use {"akinsho/nvim-bufferline.lua", requires = {"kyazdani42/nvim-web-devicons", opt = true}}

    use {
        "kyazdani42/nvim-tree.lua",
        cmd = {"NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile"},
        requires = {"kyazdani42/nvim-web-devicons", opt = true},

    }

    use {"hoob3rt/lualine.nvim", requires = {"kyazdani42/nvim-web-devicons", opt = true}}


    -- Geneal Tools
    use {"tweekmonster/startuptime.vim", cmd = {"StartupTime"}}

    use {
        "liuchengxu/vim-which-key",
        cmd = {"WhichKey"},
        config = function()
            require("plug-config.whichkey")
        end,
    }

    use "tiagovla/ezmap.nvim"

    use {
        "voldikss/vim-floaterm",
        cmd = {"FloatermNew", "FloatermToggle"},
        config = function()
            require("plug-config.floaterm")
        end,
    }

    -- Latex
    use {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        config = function()
            vim.g.mkdp_auto_start = 0
        end,
    }

end)
