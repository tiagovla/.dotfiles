" auto-install vim-plug
" if empty(glob('~/.config/nvim/autoload/plug.vim'))
" 	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
" 	  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 	"  autocmd VimEnter * PlugInstall
" 	autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif


call plug#begin('~/.config/nvim/autoload/plugged')
    " fuzzy finder
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    " Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    " Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }
    " Plug 'junegunn/fzf.vim'
    " Plug 'junegunn/goyo.vim'
    " Plug 'kevinhwang91/rnvimr'
    
    " lsp
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'

    " surroundings
    Plug 'jiangmiao/auto-pairs'
    Plug 'machakann/vim-sandwich'

    " " Colorizer
    Plug 'norcalli/nvim-colorizer.lua'

    " Themes
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'https://github.com/joshdick/onedark.vim.git'
    Plug 'morhetz/gruvbox'
    Plug 'ghifarit53/tokyonight-vim'
    Plug 'arcticicestudio/nord-vim'

    " Bar
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'romgrk/barbar.nvim'

    " Git
    Plug 'tpope/vim-fugitive'

    " matlab
    Plug 'daeyun/vim-matlab'

    " Others
    " Plug 'mhinz/vim-startify'
    Plug 'mbbill/undotree'

    " linter + formatter
    Plug 'dense-analysis/ale'
    " Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'sheerun/vim-polyglot' "overwrites tabs
    Plug 'liuchengxu/vim-which-key'
    Plug 'tpope/vim-commentary'
    " Latex
    Plug 'lervag/vimtex'
    Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'} " for VimPlug
    " Snippets
    Plug 'SirVer/ultisnips'
    " markdown
    Plug 'gabrielelana/vim-markdown'
    Plug 'iamcco/mathjax-support-for-mkdp'
    Plug 'iamcco/markdown-preview.vim'

    " mathematica
    Plug 'voldikss/vim-mma'
call plug#end()

