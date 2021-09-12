local utils = require("utils.functions")

local function load_plugins(use)
    -- Packer
    -- use {"$HOME/github/packer.nvim"}
    use {"wbthomason/packer.nvim", opt = true}
    use "tiagovla/ezmap.nvim"

    -- theme
    use {"tiagovla/tokyodark.nvim"}

    use {"akinsho/nvim-bufferline.lua", require("plug-config.bufferline")}
    use {"hoob3rt/lualine.nvim", require("plug-config.lualine")}

    -- FZF
    use {"nvim-telescope/telescope.nvim", require("plug-config.telescope")}

    -- Formatting
    use {"norcalli/nvim-colorizer.lua", require("plug-config.colorizer")}
    use {"tpope/vim-commentary", event = "BufRead"}
    use {"tpope/vim-surround", event = "BufRead"}

    -- LSP + Git
    use {"onsails/lspkind-nvim", require("plug-config.lspkind")}
    use {"glepnir/lspsaga.nvim", require("plug-config.lspsaga")}
    use {"hrsh7th/nvim-cmp", require("plug-config.cmp")}

    use {"$HOME/github/lspconfigplus", require("plug-config.lsp")}
    use {"ray-x/lsp_signature.nvim"}

    use {"lewis6991/gitsigns.nvim", require("plug-config.gitsigns")}
    use {"sindrets/diffview.nvim", require("plug-config.diffview")}

    -- Debug
    use {"mfussenegger/nvim-dap", require("plug-config.dap")}

    -- Syntax
    use {"nvim-treesitter/nvim-treesitter", require("plug-config.treesitter")}
    -- use 'nvim-treesitter/playground'

    use {"kyazdani42/nvim-tree.lua", require("plug-config.nvimtree")}

    -- General Tools
    use {"tweekmonster/startuptime.vim", cmd = {"StartupTime"}}
    use {"liuchengxu/vim-which-key", require("plug-config.whichkey")}
    use {"voldikss/vim-floaterm", require("plug-config.floaterm")}
    use {"sirver/UltiSnips", require("plug-config.ultisnips")}

    -- Latex
    use {"iamcco/markdown-preview.nvim", ft = "markdown"}
    use {"tiagovla/tex-conceal.vim", ft = "tex"}
    use {'christoomey/vim-tmux-navigator'}
    use {
        'heavenshell/vim-pydocstring',
        run = 'make install',
        ft = 'python',
        config = function() vim.g.pydocstring_formatter = 'numpy' end
    }
end

local install = utils.ensure_packer_installed()
local packer = require("packer")
packer.startup(function() load_plugins(utils.packer_use) end)
if install then
    -- TODO: call this synchronously
    -- packer.install()
    -- packer.compile()
end
