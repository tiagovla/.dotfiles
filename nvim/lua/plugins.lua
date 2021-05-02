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
    use '9mm/vim-closer'
    use 'norcalli/nvim-colorizer.lua'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'

    -- LSP
    use 'glepnir/lspsaga.nvim'
    use 'hrsh7th/nvim-compe'
    use {'tiagovla/lspconfigplus', requires = {'neovim/nvim-lspconfig'}}
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}

    -- Syntax
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'nvim-treesitter/playground'

    -- Theme
    use {'akinsho/nvim-bufferline.lua', requires = {'kyazdani42/nvim-web-devicons', opt = true}}
    use {'kyazdani42/nvim-tree.lua', requires = {'kyazdani42/nvim-web-devicons', opt = true}}
    use {'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}
    use 'tiagovla/tokyodark.nvim'

    -- Geneal Tools
    use 'tweekmonster/startuptime.vim'
    use 'liuchengxu/vim-which-key'
    use 'tiagovla/ezmap.nvim'
    use 'voldikss/vim-floaterm'

    -- Latex
    use 'iamcco/markdown-preview.nvim'

end)
