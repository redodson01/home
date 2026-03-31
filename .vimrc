unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

set clipboard=unnamed
set colorcolumn=81
set cursorline
set expandtab
set hlsearch
set ignorecase
set number
set shiftwidth=2
set smartcase
set softtabstop=-1
set t_Co=16
set t_RV=

nnoremap <Leader><Esc> :nohlsearch<Enter>
nnoremap <Leader>O O<Esc>
nnoremap <Leader>o o<Esc>

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
