set nocompatible      	"No Vi Compatibility

"this does indent on return
"imap <silent> <CR> <ESC>gg=G<C-O><C-O>o

set number " line count
set smartcase "ignore case in search if no caps
set title
set backspace=indent,eol,start
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
set incsearch   			"Search Incrementally
set ruler               "Show Line Number
"set background=dark     "Use 'Dark' Color Scheme
set whichwrap+=<
set whichwrap+=>
set whichwrap+=[
set whichwrap+=]
syntax on
set gfn=Monaco:h10
set encoding=utf-8
match Todo /\s\+$/   "hilight trailing whitespace
"pcre
nnoremap / :M/
nnoremap ? :M?
nnoremap ,/ /
nnoremap ,? ?
"

set autoindent
filetype plugin indent on

set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

"save position
au BufWinLeave * mkview
au BufWinEnter * silent loadview
"center after n
"nnoremap n nzzzv

"fat finger helpers
command W w
command Wq wq

" insert FIOC breakpoint with C-b in insert mode
command Pythonbreakpoint :normal iimport code; code.interact(local=locals())<CR><ESC>
inoremap <C-b> <ESC>:Pythonbreakpoint<CR>i

"makefile force real tabs
autocmd BufEnter ?akefile* set noet ts=8 sw=8 nocindent
autocmd BufEnter *.lib setf sh
autocmd BufEnter *.module setf php
autocmd BufEnter *.theme setf php
autocmd BufEnter *.py :inoremap # X<C-H>#

hi clear SpellBad
hi SpellBad cterm=underline
