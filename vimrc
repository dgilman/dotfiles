set nocompatible

" This turns on all the language support magic?
filetype plugin indent on

" Sensible encoding defaults
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" Tell vim to optimize for drawing on fast, modern terminals
set ttyfast

" Kill ALL the mouse stuff
set mouse=
set ttymouse=

" Fix backspace indent
set backspace=indent,eol,start

" Tabs. May be overridden by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

" Yellow box around matches
set hlsearch
" Live search results
set incsearch

set fileformats=unix,dos,mac

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

" syntax hilighting
syntax on
" show line numbers in the bottom row
set ruler
" left hand side line numbering
set number

" Try and use 256 colors
set t_Co=256

" Don't clear with the background color? idk
if &term =~ '256color'
  set t_ut=
endif

" Enable the second from the bottom status line
set laststatus=2

" Enable modelines
set modeline
set modelines=10

" Enable vim setting the title in the terminal emulator
" ("Thanks for flying Vim")
set title
" Use the filepath as the title
set titlestring=%F

" Contents of the second-from-the-bottom line
set statusline=%F%m%r%h%w%=(%l\/%L,\ %c)

" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Handle some typos
command W w
command Q q
command Wq wq

" force hard tabs in makefiles
autocmd BufEnter ?akefile* setlocal noexpandtab ts=8 sw=8 nocindent
autocmd BufEnter CMakeLists.txt* setlocal filetype=cmake

" copy to the mac clipboard with cmd-x cmd-c
if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

" python
" vim-python
augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

" Enable persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

" Use colors for a white terminal background
set background=light

" Yell at user for trailing whitespace
match Todo /\s\+$/

" Let left-right motion wrap around to the prev/following lines
set whichwrap+=<
set whichwrap+=>
set whichwrap+=[
set whichwrap+=]

" save and restore position in the file
au BufWinLeave * mkview
au BufWinEnter * silent loadview

" eregex.vim maps
nnoremap / :M/
nnoremap ? :M?
nnoremap ,/ /
nnoremap ,? ?

