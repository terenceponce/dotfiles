set nocompatible
let g:mapleader=" "

call plug#begin('~/.vim/vendor')

if !has('nvim') && !exists('g:gui_oni') | Plug 'tpope/vim-sensible' | endif
Plug 'rstacruz/vim-opinion'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'altercation/vim-colors-solarized'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chaoren/vim-wordmotion'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'rstacruz/vim-closer'
Plug 'tpope/vim-rails'
Plug 'neoclide/coc.nvim', { 'tag': 'v0.0.82' }
Plug 'nathanaelkane/vim-indent-guides'

call plug#end()

let g:coc_global_extensions = ['coc-solargraph', 'coc-json']
