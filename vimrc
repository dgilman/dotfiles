set nocompatible      	"No Vi Compatibility

set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

set number " line count
set smartcase "ignore case in search if no caps
set title
set backspace=2         "Enable Backspacing
set autoindent          "Enable Autoindenting
set smartindent       	"Enable Smartindenting
set tabstop=3				"Set Tabs at 3 Spaces
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
