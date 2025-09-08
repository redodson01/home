unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

set expandtab
set shiftwidth=2
set softtabstop=-1
set t_Co=16
set t_RV=

if !empty(glob('~/.vim/autoload/plug.vim'))
  call plug#begin()
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'lifepillar/vim-solarized8'
  call plug#end()
endif

if !empty(glob('~/.vim/plugged/vim-solarized8/colors/solarized8.vim'))
  colorscheme solarized8
endif
