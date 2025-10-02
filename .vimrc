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

nnoremap <Leader><Esc> :nohlsearch<Enter>

if !empty(glob('~/.vim/autoload/plug.vim'))
  call plug#begin()
  Plug 'altercation/vim-colors-solarized'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  call plug#end()
endif

if !empty(glob('~/.vim/plugged/vim-colors-solarized/colors/solarized.vim'))
  colorscheme solarized
endif
