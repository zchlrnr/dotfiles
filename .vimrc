"Set Basic Shit
set nocompatible
filetype on
set incsearch
set autoindent
set foldcolumn=3
set foldmethod=marker
set rnu
set clipboard=unnamed
set shiftwidth=4
set tabstop=4
set expandtab
set history=500
set showcmd
let g:markdown_folding=1
syntax enable

autocmd FileType matlab setlocal textwidth=80
autocmd FileType markdown setlocal textwidth=80

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"Plugin 'plasticboy/vim-markdown'
Plugin 'vim-airline/vim-airline'

call vundle#end()            " required
filetype plugin indent on    " required
