set nocompatible      	"No Vi Compatibility

"set undodir=~/.vim/undodir
"set undofile
"set undolevels=1000 "maximum number of changes that can be undone
"set undoreload=10000 "maximum number lines to save for undo on a buffer reload

"this does indent on return
"imap <silent> <CR> <ESC>gg=G<C-O><C-O>o

set number " line count
set smartcase "ignore case in search if no caps
set title
set backspace=2         "Enable Backspacing
set autoindent          "Enable Autoindenting
set smartindent       	"Enable Smartindenting
set tabstop=3				"Set Tabs at 3 Spaces
set expandtab
set shiftwidth=3			"Set Shifts at 3 Spaces
"set nohls					"Do Not Highlight Search Results
set incsearch   			"Search Incrementally
set ruler               "Show Line Number
"set background=dark     "Use 'Dark' Color Scheme
"set mouse=a             "Enable Using the Mouse
set whichwrap+=<
set whichwrap+=>
set whichwrap+=[
set whichwrap+=]
syntax on
set gfn=Monaco:h10
set encoding=utf-8
match Todo /\s\+$/
"pcre
nnoremap / :M/
nnoremap ? :M?
nnoremap ,/ /
nnoremap ,? ?
"
filetype plugin on
"save position
au BufWinLeave * mkview
au BufWinEnter * silent loadview
"center after n
"nnoremap n nzzzv

command W w
command Wq wq

set encoding=utf8

"makefile force real tabs
autocmd BufEnter ?akefile* set noet ts=8 sw=8 nocindent
autocmd BufEnter *.lib setf sh
autocmd BufEnter *.module setf php
autocmd BufEnter *.theme setf php
autocmd BufEnter *.py :inoremap # X<C-H>#
