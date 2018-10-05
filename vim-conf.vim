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
" Global Plugins "
Plugin 'gorkunov/smartpairs.vim'
Plugin 'ervandew/supertab'

" Python Plugins "
Plugin 'fisadev/vim-isort'
Plugin 'ambv/black'
Plugin 'nvie/vim-flake8'
Plugin 'chr4/nginx.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'heavenshell/vim-pydocstring'

" Javascript Plugins "
Plugin 'posva/vim-vue'
Plugin 'alvan/vim-closetag'
Plugin 'larsbs/vimterial'

" Rust Plugins "
Plugin 'rust-lang/rust.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
syntax on


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Plugin Setup                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Jedi - Autocompletion for Python "
let g:jedi#popup_on_dot = 0
let g:jedi#use_splits_not_buffers = "bottom"

" SuperTab - Autocompletion set to <Tab> "
let g:SuperTabDefaultCompletionType = "context"

" Flake8 & Black - Python formatting "
let g:flake8_show_in_file = 1
autocmd BufWritePre *.py execute ':Black'
autocmd BufWritePre *.py execute ':Isort'
autocmd BufWritePost *.py call Flake8()

" Pydocstrings - Autocompletion for Python Docstrings "
nmap <silent> <leader>ds <Plug>(pydocstring)

" closetag - closing tags automatically "
let g:closetag_filenames = '*.html,*.vue'
let g:closetag_filetypes = '*.html,*.vue'

" Rust-Lang - Formatting & Autocompletion "
let g:rustfmt_autosave = 1

" CPP "
autocmd BufWritePre *.c execute ':%!astyle'
autocmd BufWritePre *.cpp execute ':%!astyle'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Key Bindings                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "\\"
nmap <S-L> :w!<cr>
nmap <S-K> :wq!<cr>

set backspace=2

set pastetoggle=<F12>

vnoremap < <gv
vnoremap > >gv

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Global Config                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Number of lines to remember "
set history=1500

" Smart indenting "
set ai
set si
set wrap

" continue where you last left off "
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                    Filetypes                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Javascript "
au BufNewFile,BufRead,BufEnter *.ts set ft=javascript
au BufNewFile,BufRead,BufEnter *.cs set ft=javascript
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Vue "
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
autocmd FileType vue syntax sync fromstart
autocmd FileType vue setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Python "
au FileType python let python_highlight_all = 1
au FileType python set listchars=eol:¬,tab:▷\ ,
au FileType python set colorcolumn=80
au FileType python highlight ColorColumn ctermbg=5
au FileType python syn keyword pythonDecorator True None False self
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

au BufNewFile,BufRead *.jinja set syntax=htmljinja


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Color Schemes                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Javascript "
autocmd BufNewFile,BufRead,BufEnter *.ts set t_Co=256
autocmd BufNewFile,BufRead,BufEnter *.ts colorscheme distinguished
autocmd BufNewFile,BufRead,BufEnter *.js set t_Co=256
autocmd BufNewFile,BufRead,BufEnter *.js colorscheme distinguished
autocmd BufNewFile,BufRead,BufEnter *.cs set t_Co=256
autocmd BufNewFile,BufRead,BufEnter *.cs colorscheme distinguished

" Python "
autocmd BufNewFile,BufRead,BufEnter *.py set t_Co=256
autocmd BufNewFile,BufRead,BufEnter *.py colorscheme distinguished

" CPP "
autocmd BufNewFile,BufRead,BufEnter *.cpp set t_Co=256
autocmd BufNewFile,BufRead,BufEnter *.cpp colorscheme distinguished

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

function! <SID>StripTrailingWhitespaces()
	let l = line(".")
	let c = col(".")
	%s/\s\+$//e
	call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Auto-Detect Changes                           "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup myvimrc
	au!
	autocmd BufWritePost .vimrc source ~/.vimrc
augroup END
