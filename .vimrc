"Set Basic Shit
set nocompatible
filetype on
"color default
color elflord
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
syntax enable
set textwidth=80

" Filetype specific shit
autocmd FileType text setlocal textwidth=120
" Matlab
autocmd FileType matlab setlocal textwidth=100
" Markdown
autocmd FileType markdown setlocal textwidth=100
" Python
autocmd FileType python setlocal textwidth=100
autocmd FileType python setlocal colorcolumn=100
" Nastran bdf
au BufRead,BufNewFile *bdf set filetype=Nastran
au! Syntax Nastran source /usr/share/vim/vim81/syntax/nastran.vim
" Fortran
autocmd FileType fortran setlocal textwidth=120

"call plug#begin('~/.vim/plugged')

"Plug 'vim-airline/vim-airline'
"Plug 'plasticboy/vim-markdown'
"Plug 'vim-airline/vim-airline-themes'

"call plug#end()

" Plugin settings
"let g:markdown_folding=1
"let g:airline_theme='violet'


