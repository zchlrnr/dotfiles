"Set Basic Shit
set nocompatible
filetype on
"color default
color desert
set incsearch
set autoindent
set foldcolumn=3
set foldmethod=marker
set rnu
set nu
set clipboard=unnamed
set shiftwidth=4
set tabstop=4
set expandtab
set history=500
set showcmd
let g:markdown_folding=1
syntax enable
set textwidth=80

autocmd FileType matlab setlocal textwidth=100
autocmd FileType markdown setlocal textwidth=80
autocmd FileType python setlocal textwidth=100
autocmd FileType python setlocal colorcolumn=100

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"Plugin 'plasticboy/vim-markdown'
Plugin 'vim-airline/vim-airline'
Plugin 'mohetz/gruvbox'

call vundle#end()            " required
filetype plugin indent on    " required
