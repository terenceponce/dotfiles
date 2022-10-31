" Start fzf in a pop-up centered window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" Make ripgrep ignore file names in text search
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
