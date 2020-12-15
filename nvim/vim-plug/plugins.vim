" auto-install vim-plug
" if empty(glob('~/.config/nvim/autoload/plug.vim'))
" 	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
" 	  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 	"  autocmd VimEnter * PlugInstall
" 	autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif


call plug#begin('~/.config/nvim/autoload/plugged')

	" Auto pairs for '(' '[' '{'
	" Plug 'jiangmiao/auto-pairs'
	" FZF
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }
	Plug 'junegunn/fzf.vim'
    Plug 'junegunn/goyo.vim'
    "Git
    " 	Plug 'tpope/vim-fugitive'
    "Tabline
    " Plug 'romgrk/barbar.nvim'
    " Plug 'kyazdani42/nvim-web-devicons'
    " Plug 'bling/vim-bufferline'
    " Colorizer
    Plug 'norcalli/nvim-colorizer.lua'
    " Themes
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'https://github.com/joshdick/onedark.vim.git'
    Plug 'morhetz/gruvbox'
    Plug 'ghifarit53/tokyonight-vim'
    Plug 'arcticicestudio/nord-vim'
    "Others
    Plug 'tpope/vim-fugitive'
    " matlab
    Plug 'daeyun/vim-matlab'
    " Plug 'https://github.com/Valloric/YouCompleteMe.git'
    Plug 'mbbill/undotree'
    Plug 'dense-analysis/ale'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'sheerun/vim-polyglot'
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
call plug#end()

