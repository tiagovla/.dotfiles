-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Packer
    use {'wbthomason/packer.nvim', opt = true}

    -- FZF
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
    use 'nvim-telescope/telescope-media-files.nvim'

    -- Formatting
    use 'jiangmiao/auto-pairs'
    use 'machakann/vim-sandwich'
    use 'norcalli/nvim-colorizer.lua'
    use 'tpope/vim-commentary'

    -- LSP
    use 'neovim/nvim-lspconfig'
    -- use 'nvim-lua/completion-nvim'
    use 'hrsh7th/nvim-compe'

    -- Closer 
    use '9mm/vim-closer'

    -- Syntax
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- Theme 
    use {
        'akinsho/nvim-bufferline.lua',
        requires = 'kyazdani42/nvim-web-devicons'
    }

    use {'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons'}

    use {
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
    -- use 'morhetz/gruvbox'
    use 'gruvbox-community/gruvbox'
    use 'ghifarit53/tokyonight-vim'
    use 'arcticicestudio/nord-vim'

    -- Tools
    use 'tpope/vim-fugitive'
    use 'mbbill/undotree'
    use 'puremourning/vimspector'

    -- Snips
    use {
        'SirVer/ultisnips',
        config = function()
            vim.g.UltiSnipsExpandTrigger = '<nop>'
            vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
            vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
            vim.g.UltiSnipsSnippetDirectories = {"UltiSnips", "snips"}
        end
    }
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'

    -- General
    use 'liuchengxu/vim-which-key'
    use 'voldikss/vim-floaterm'

end)
