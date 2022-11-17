" Enable 256-color by default in the terminal
if !has('gui_running') | set t_Co=256 | endif

syntax enable
set background=light
colorscheme solarized

" Start fzf in a pop-up centered window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" Make ripgrep ignore file names in text search
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Temporary fix for NERDTree bug with latest version of neovim
" https://github.com/preservim/nerdtree/issues/1321
let g:NERDTreeMinimalMenu=1

" Change vim-airline theme to Solarized Light
let g:airline_theme='solarized'

set undofile
set undodir=~/.vim/undo/

" Change color of vim-gitgutter column
" Always keep this line at the end of the file
highlight clear SignColumn
