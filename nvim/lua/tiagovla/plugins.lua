utils = require "tiagovla.utils.plugins"
local load_cfg = utils.load_cfg

plugins = {
    { "wbthomason/packer.nvim", opt = true },

    -- Themes
    { "tiagovla/tokyodark.nvim" },
    { "akinsho/nvim-bufferline.lua", load_cfg "bufferline" },
    { "hoob3rt/lualine.nvim", load_cfg "lualine" },

    -- FZF
    { "nvim-telescope/telescope.nvim", load_cfg "telescope" },
    { "akinsho/toggleterm.nvim", load_cfg "toggleterm" },

    -- Formatting
    { "norcalli/nvim-colorizer.lua", load_cfg "colorizer" },
    { "tpope/vim-commentary", event = "BufRead" },

    -- LSP + Git
    { "onsails/lspkind-nvim", load_cfg "lspkind" },
    { "hrsh7th/nvim-cmp", load_cfg "cmp" },
    { "tiagovla/lspconfigplus", load_cfg "lsp" },
    { "ray-x/lsp_signature.nvim" },
    { "lewis6991/gitsigns.nvim", load_cfg "gitsigns" },
    { "sindrets/diffview.nvim", load_cfg "diffview" },

    -- Debug
    { "mfussenegger/nvim-dap", load_cfg "dap" },

    -- Syntax
    { "nvim-treesitter/nvim-treesitter", load_cfg "treesitter" },
    { "nvim-treesitter/playground", after = "nvim-treesitter" },
    { "kyazdani42/nvim-tree.lua", load_cfg "nvimtree" },

    -- -- General Tools
    { "folke/trouble.nvim", load_cfg "trouble" },
    { "folke/which-key.nvim", load_cfg "whichkey" },
    { "nvim-telescope/telescope-project.nvim", load_cfg "project" },

    -- Lua
    { "sirver/UltiSnips", load_cfg "ultisnips" },

    -- Latex
    { "iamcco/markdown-preview.nvim", load_cfg "markdownpreview" },
    { "tiagovla/tex-conceal.vim", ft = "tex" },
    { "christoomey/vim-tmux-navigator" },
    { "kkoomen/vim-doge", load_cfg "vimdoge" },
}

packer = require "packer"

packer.startup(function()
    for _, plugin in pairs(plugins) do
        utils.packer_use(plugin)
    end
end)
