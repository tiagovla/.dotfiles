local packer, use, use_local = unpack(require "plugins.packer")

packer.startup {
    function()
        -- Base
        use { "wbthomason/packer.nvim", opt = true }
        use { "lewis6991/impatient.nvim" }
        use { "nvim-lua/plenary.nvim" }

        -- Themes
        use_local { "tiagovla/tokyodark.nvim" }
        use { "kyazdani42/nvim-web-devicons", after = "tokyodark.nvim" }
        use { "nvim-lualine/lualine.nvim", after = "nvim-web-devicons", ext = "lualine" }
        use { "akinsho/nvim-bufferline.lua", after = "nvim-web-devicons", ext = "bufferline" }

        -- Telescope
        use { "nvim-telescope/telescope.nvim", module = "telescope", ext = "telescope" }
        use { "nvim-telescope/telescope-media-files.nvim", after = "telescope.nvim" }
        use { "tiagovla/telescope-project.nvim", after = "telescope.nvim", ext = "project" }
        use { "nvim-telescope/telescope-file-browser.nvim", after = "telescope.nvim" }
        use { "jvgrootveld/telescope-zoxide", after = "telescope.nvim", ext = "telescope-zoxide" }

        -- Syntax
        use { "nvim-treesitter/nvim-treesitter", event = "BufRead", ext = "treesitter" }
        use { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" }

        -- Lsp
        use { "williamboman/nvim-lsp-installer", event = "BufReadPre" }
        use { "neovim/nvim-lspconfig", after = "nvim-lsp-installer", ext = "lsp" }
        use { "microsoft/python-type-stubs", opt = true }

        -- Git
        use { "lewis6991/gitsigns.nvim", ext = "gitsigns" }
        use { "TimUntersberger/neogit", cmd = { "Neogit" }, ext = "neogit" }

        -- Auto-complete
        use { "rafamadriz/friendly-snippets", event = "InsertEnter" }
        use { "L3MON4D3/LuaSnip", after = "friendly-snippets", module = "luasnip" }
        use { "hrsh7th/nvim-cmp", after = "LuaSnip", ext = "cmp" }
        use { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" }
        use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
        use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
        use { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" }
        use { "kdheepak/cmp-latex-symbols", after = "nvim-cmp" }
        use { "hrsh7th/cmp-path", after = "nvim-cmp" }
        use { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" }
        use { "onsails/lspkind-nvim", after = "nvim-cmp", ext = "lspkind" }
        use { "tami5/sqlite.lua", branch = "feat/support_sqlite_open_v2" }
        use_local { "tiagovla/zotex.nvim", after = "nvim-cmp" }

        -- UI Helpers
        use { "mbbill/undotree", cmd = "UndotreeToggle" }
        use { "kyazdani42/nvim-tree.lua", wants = { "nvim-treesitter" }, ext = "nvimtree" }
        use { "christoomey/vim-tmux-navigator", ext = "vim_tmux_navigator" }
        use { "luukvbaal/stabilize.nvim", event = "BufRead", ext = "stabilize" }
        use { "akinsho/toggleterm.nvim", cmd = "ToggleTerm", ext = "toggleterm" }
        use { "sindrets/diffview.nvim", ext = "diffview" }
        use { "folke/trouble.nvim", cmd = { "Trouble" }, module = "trouble", ext = "trouble" }
        use { "rcarriga/nvim-notify", after = "telescope.nvim", ext = "nvim-notify" }
        use { "xiyaowong/which-key.nvim", lock = true, ext = "whichkey" }
        use { "andweeb/presence.nvim", after = "telescope.nvim", ext = "presence" }
        use_local { "tiagovla/scope.nvim", ext = "scope", event = "BufRead" }
        use_local { "tiagovla/buffercd.nvim", ext = "buffercd", event = "BufRead" }
        use { "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline" }

        -- Commenter & Colorizer
        use { "norcalli/nvim-colorizer.lua", event = "BufRead", ext = "colorizer" }
        use { "numToStr/Comment.nvim", event = "BufRead", ext = "comment" }

        -- Documents
        use { "tiagovla/tex-conceal.vim", ft = "tex" }
        use { "iamcco/markdown-preview.nvim", ext = "markdownpreview" }
        use { "danymat/neogen", ext = "neogen" }

        -- Debug
        use { "mfussenegger/nvim-dap", module = "dap", ext = "dap" }
        use "folke/lua-dev.nvim"
        -- use { "nvim-treesitter/playground", after = "nvim-treesitter"}
    end,
    -- config = {
    --     compile_path = vim.fn.stdpath "config" .. "/plugin/packer_compiled.lua",
    -- },
}
