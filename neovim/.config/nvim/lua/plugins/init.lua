local packer = require "plugins.packer"

local use = function(config)
    if config.ext then
        config = vim.tbl_deep_extend("force", config, config.ext)
        config.ext = nil
    end
    packer.use(config)
end
local function use_local(config) end

local load = function(path)
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
        use { "tiagovla/tokyodark.nvim" }
        use { "kyazdani42/nvim-web-devicons", after = "tokyodark.nvim" }
        use { "nvim-lualine/lualine.nvim", after = "nvim-web-devicons", ext = load "lualine" }
        use { "akinsho/nvim-bufferline.lua", after = "nvim-web-devicons", ext = load "bufferline" }

        -- Telescope
        use { "nvim-telescope/telescope.nvim", ext = load "telescope", module = "telescope" }
        use { "nvim-telescope/telescope-media-files.nvim", after = "telescope.nvim" }
        use { "nvim-telescope/telescope-project.nvim", ext = load "project", after = "telescope.nvim" }
        use { "$HOME/github/session-lens", after = "telescope.nvim" }

        -- Syntax
        use { "nvim-treesitter/nvim-treesitter", event = "BufRead", ext = load "treesitter" }

        -- Lsp
        use { "tiagovla/lspconfigplus", ext = load "lsp", event = "BufReadPre" }
        use { "ray-x/lsp_signature.nvim", after = "lspconfigplus" }

        -- Git
        use { "lewis6991/gitsigns.nvim", ext = load "gitsigns" }
        use { "TimUntersberger/neogit", ext = load "neogit", cmd = { "Neogit" } }

        -- Auto-complete
        use { "hrsh7th/nvim-cmp", event = "InsertEnter", ext = load "cmp" }
        use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
        use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
        use { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" }
        use { "kdheepak/cmp-latex-symbols", after = "nvim-cmp" }
        use { "hrsh7th/cmp-path", after = "nvim-cmp" }
        use { "onsails/lspkind-nvim", ext = load "lspkind", after = "nvim-cmp" }

        -- UI Helpers
        use { "kyazdani42/nvim-tree.lua", ext = load "nvimtree" }
        use { "christoomey/vim-tmux-navigator", event = "VimEnter" }
        use { "luukvbaal/stabilize.nvim", event = "BufRead", ext = load "stabilize" }
        use { "akinsho/toggleterm.nvim", ext = load "toggleterm", cmd = "ToggleTerm" }
        use { "sindrets/diffview.nvim", ext = load "diffview" }
        use { "folke/trouble.nvim", cmd = { "Trouble" }, ext = load "trouble", module = "trouble" }
        use { "folke/which-key.nvim", ext = load "whichkey", event = "VimEnter" }

        -- Commenter & Colorizer
        use { "norcalli/nvim-colorizer.lua", event = "BufRead", ext = load "colorizer" }
        use { "tpope/vim-commentary", event = "BufRead" }

        -- Documents
        use { "tiagovla/tex-conceal.vim", ft = "tex" }
        use { "iamcco/markdown-preview.nvim", ext = load "markdownpreview" }
        use { "kkoomen/vim-doge", ext = load "vimdoge" }

        -- Debug
        use { "mfussenegger/nvim-dap", ext = load "dap" }
        -- use { "nvim-treesitter/playground", after = "nvim-treesitter"}
        -- use { "dstein64/vim-startuptime"}
    end,
    -- config = {
    --     compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
    -- },
}
