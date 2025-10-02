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
nnoremap <Leader>a     :Ag<Enter>
nnoremap <Leader>b     :Buffers<Enter>
nnoremap <Leader>f     :Files<Enter>
nnoremap <Leader>g     :GitFiles<Enter>
nnoremap <Leader>r     :Rg<Enter>

if !empty(glob('~/.vim/autoload/plug.vim'))
  call plug#begin()
  Plug 'altercation/vim-colors-solarized'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  call plug#end()
endif

if !empty(glob('~/.vim/plugged/vim-colors-solarized/colors/solarized.vim'))
  colorscheme solarized
endif
