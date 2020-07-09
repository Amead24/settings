""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Vundle Setup                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Input all of your Plugins after this line
Plugin 'morhetz/gruvbox'

" Javascript Plugins "
Plugin 'alvan/vim-closetag'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
syntax on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Global Config                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Number of lines to remember "
set history=1500

" Smart indenting "
set autoindent
set smartindent
set wrap
set number

" enable home/end keys "
set term=xterm-256color

" continue where you last left off "
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Key Bindings                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","
imap jj <Esc>
nmap <S-L> :w!<cr>  # Quick save
nmap <S-K> :wq!<cr> # Quick save & quit
vnoremap < <gv
vnoremap > >gv

set backspace=2
set pastetoggle=<F12>
set list

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Plugin Setup                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Flake8 & Black - Python formatting "
" closetag - closing tags automatically "
let g:closetag_filenames = '*.html,*.vue'
let g:closetag_filetypes = '*.html,*.vue'

" closetag - closing tags automatically "
let g:closetag_filenames = '*.html,*.vue'
let g:closetag_filetypes = '*.html,*.vue'

autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>b  <Plug>(go-build)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                    Filetypes                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YAML "
au BufNewFile,BufRead,BufEnter *.yml set ft=yaml
au BufNewFile,BufRead,BufEnter *.yaml set ft=yaml
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Javascript "
au BufNewFile,BufRead,BufEnter *.ts set ft=javascript
au BufNewFile,BufRead,BufEnter *.cs set ft=javascript
au BufNewFile,BufRead,BufEnter *.html set ft=javascript
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Vue "
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
autocmd FileType vue syntax sync fromstart
autocmd FileType vue setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Python "
au FileType python let python_highlight_all = 1
au FileType python set listchars=eol:¬,tab:▷\ ,
au FileType python syn keyword pythonDecorator True None False self
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
au BufNewFile,BufRead *.jinja set syntax=htmljinja

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Color Schemes                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256
colorscheme gruvbox
set background=dark
let g:airline_theme='aurora'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Open & Close Containers                           "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
autocmd Syntax html,vim inoremap < <lt>><Esc>i| inoremap > <c-r>=ClosePair('>')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap } <c-r>=ClosePair('}')<CR>
inoremap " <c-r>=QuoteDelim('"')<CR>
inoremap ' <c-r>=QuoteDelim("'")<CR>

function! ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
  return "\<Right>"
  else
    return a:char
  endif
endf

function! CloseBracket()
  if match(getline(line('.') + 1), '\s*}') < 0
    return "\<CR>}"
  else
    return "\<Esc>j0f}a"
  endif
 endf

function! QuoteDelim(char)
  let line = getline('.')
  let col = col('.')
  if line[col - 2] == "\\"
    "Inserting a quoted quotation mark into the string
    return a:char
  elseif line[col - 1] == a:char
    "Escaping out of the string
    return "\<Right>"
  else
    "Starting a string
    return a:char.a:char."\<Esc>i"
  endif
endf

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Auto-Detect Changes                           "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup myvimrc
	au!
	autocmd BufWritePost .vimrc source ~/.vimrc
augroup END
