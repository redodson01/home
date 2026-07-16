unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

set expandtab
set shiftwidth=2
set softtabstop=-1

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
  let g:solarized_use16=1
  colorscheme solarized8
endif
