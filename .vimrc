unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

set clipboard=unnamed
set colorcolumn=81
set expandtab
set hlsearch
set ignorecase
set number
set shiftwidth=2
set smartcase
set softtabstop=-1

if &term =~# '^tmux'
  let &t_RB = "\e]11;?\007"
endif

if !empty(glob('~/.vim/autoload/plug.vim'))
  call plug#begin()
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'lifepillar/vim-solarized8'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  call plug#end()
endif

if !empty(glob('~/.vim/plugged/vim-solarized8/colors/solarized8.vim'))
  colorscheme solarized8
endif
