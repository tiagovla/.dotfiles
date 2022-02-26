local packer = require "plugins.packer"

local use = function(config)
    if config.ext then
        config = vim.tbl_deep_extend("force", config, config.ext)
        config.ext = nil
    end
    packer.use(config)
end
local function use_local(config) end -- TODO: Implement use_local feature

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

packer.startup {
    function()
        -- Base
        use { "wbthomason/packer.nvim", opt = true }
        use { "lewis6991/impatient.nvim" }
        use { "nvim-lua/plenary.nvim" }
        use { "nvim-lua/popup.nvim" }

        -- Themes
        use { "tiagovla/tokyodark.nvim" } -- tiagovla/tokyodark.nvim
        use { "kyazdani42/nvim-web-devicons", after = "tokyodark.nvim" }
        use { "nvim-lualine/lualine.nvim", after = "nvim-web-devicons", ext = load "lualine" }
        use { "akinsho/nvim-bufferline.lua", after = "nvim-web-devicons", ext = load "bufferline" }

        -- Telescope
        use { "nvim-telescope/telescope.nvim", module = "telescope", ext = load "telescope" }
        use { "nvim-telescope/telescope-media-files.nvim", after = "telescope.nvim" }
        use { "tiagovla/telescope-project.nvim", after = "telescope.nvim", ext = load "project" }

        -- Syntax
        use { "nvim-treesitter/nvim-treesitter", event = "BufRead", ext = load "treesitter" }
        use { "microsoft/python-type-stubs", opt = true }

        -- Lsp
        use { "williamboman/nvim-lsp-installer", event = "BufReadPre" }
        use { "neovim/nvim-lspconfig", after = "nvim-lsp-installer", ext = load "lsp" }

        -- Git
        use { "lewis6991/gitsigns.nvim", ext = load "gitsigns" }
        use { "TimUntersberger/neogit", cmd = { "Neogit" }, ext = load "neogit" }

        -- Auto-complete
        use { "rafamadriz/friendly-snippets", event = "InsertEnter" }
        use { "hrsh7th/nvim-cmp", after = "friendly-snippets", ext = load "cmp" }
        use { "L3MON4D3/LuaSnip", wants = "friendly-snippets", after = "nvim-cmp", module = "luasnip" }
        use { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" }
        use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
        use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
        use { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" }
        use { "kdheepak/cmp-latex-symbols", after = "nvim-cmp" }
        use { "hrsh7th/cmp-path", after = "nvim-cmp" }
        use { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" }
        use { "onsails/lspkind-nvim", after = "nvim-cmp", ext = load "lspkind" }

        -- UI Helpers
        use { "kyazdani42/nvim-tree.lua", wants = { "nvim-treesitter" }, ext = load "nvimtree" }
        use { "christoomey/vim-tmux-navigator", ext = load "vim_tmux_navigator" }
        use { "luukvbaal/stabilize.nvim", event = "BufRead", ext = load "stabilize" }
        use { "akinsho/toggleterm.nvim", cmd = "ToggleTerm", ext = load "toggleterm" }
        use { "sindrets/diffview.nvim", ext = load "diffview" }
        use { "folke/trouble.nvim", cmd = { "Trouble" }, module = "trouble", ext = load "trouble" }
        use { "rcarriga/nvim-notify", ext = load "nvim-notify" }
        use { "folke/which-key.nvim", lock = true, ext = load "whichkey" }
        use { "andweeb/presence.nvim", ext = load "presence" }

        -- Commenter & Colorizer
        use { "norcalli/nvim-colorizer.lua", event = "BufRead", ext = load "colorizer" }
        use { "tpope/vim-commentary", event = "BufRead" }

        -- Documents
        use { "tiagovla/tex-conceal.vim", ft = "tex" }
        use { "iamcco/markdown-preview.nvim", ext = load "markdownpreview" }
        use { "danymat/neogen", ext = load "neogen" }

        -- Debug
        use { "mfussenegger/nvim-dap", module = "dap", ext = load "dap" }
        -- use { "nvim-treesitter/playground", after = "nvim-treesitter"}
    end,
    config = {
        compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
    },
}
