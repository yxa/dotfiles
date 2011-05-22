
set title           " show title in console title bar
set ttyfast         " smoother changes

" Set status line
set statusline=[%02n]\ %f\ %(\[%M%R%H]%)%=\ %4l,%02c%2V\ %P%*

" Always display a status line at the bottom of the window
set laststatus=2

"enable mouse
set mouse=a

"lets you navigate away from unsaved buffers
set hidden

"dont display the welcome screen
set shortmess=filnxtToOI

set listchars=tab:>.

set nocompatible
syntax on
filetype plugin indent on

"no backups
set nobackup
set nowritebackup

"no swap files
set noswapfile

"set the height of my window:
set lines=50

"set the width:
set columns=100
set spell

set autoindent

"i like to see line numbers
set number
"highlight the line the cursor is on
set cursorline

"turn syntax highlightning on
syntax on


set formatprg=par

set tabstop=2 shiftwidth=2 expandtab

set hlsearch

"turn of the beeping
set vb
