unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

set expandtab
set shiftwidth=2
set softtabstop=-1

if !empty(glob('~/.vim/autoload/plug.vim'))
  call plug#begin()
  call plug#end()
endif
