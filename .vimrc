call pathogen#infect()
syntax on
filetype plugin indent on

set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]


" show and hide invisible charactes
nmap <F3> :set list!<CR>

set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,nbsp:_
highlight SpecialKey term=standout ctermbg=yellow guibg=yellow


" Highlight the selected entry in the tree
let NERDTreeHighlightCursorline=1

" Use a single click to fold/unfold directories and a double click to open
let NERDTreeMouseMode=2

map <F2> :NERDTreeToggle<CR>

let g:NERDTreeDirArrows=0

" Store the bookmarks file
let NERDTreeBookmarksFile=expand("$HOME/.vim/NERDTreeBookmarks")

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1

set backupdir=~/vimtmp,.
set directory=~/vimtmp,.

let mapleader = ","

" Softtabs, 2 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Use Ack instead of Grep when available
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif

" Numbers
set number
set numberwidth=5


set showmode
set nocompatible  " Use Vim settings, rather then Vi settings
set nobackup
set nowritebackup
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line


" Avoid accidental hits of <F1> while aiming for <Esc>
map! <F1> <Esc>

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction
  
function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction


function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

nnoremap <F5> :call <SID>StripTrailingWhitespaces()<CR>
autocmd BufWritePre *.py,*.js :call <SID>StripTrailingWhitespaces()

map <F4> :FufFile **/<CR>
let g:fuf_file_exclude = '\v\~$' 
      \ . '|\.(o|png|PNG|JPG|class|CLASS|jpg|exe|bak|swp)$' 
      \ . '|(^|[/\\])\.(hg|git|bzr)($|[/\\])' 
      \ . '|(^|[/\\])node_modules[/\\]' 
      \ . '|(^|[/\\])assets[/\\]' 
      \ . '|(^|[/\\])target[/\\]' 
      \ . '|(^|[/\\])external_resources[/\\]' 
      \ . '|(^|[/\\])plugins[/\\]' 
      \ . '|.*[/\\]$' 

" enable and disable highlightning
:set hlsearch
:noremap <F6> :set hlsearch! hlsearch?<CR>

"vimux plugin mappings
" Run the current file with rspec
map <Leader>rb :call RunVimTmuxCommand("clear; rspec " . bufname("%"))<CR>

" Prompt for a command to run
map rp :PromptVimTmuxCommand<CR>

" Run last command executed by RunVimTmuxCommand
map <Leader>rl :RunLastVimTmuxCommand<CR>

" Inspect runner pane
map <Leader>ri :InspectVimTmuxRunner<CR>
"
" Close all other tmux panes in current window
map <Leader>rx :CloseVimTmuxPanes<CR>

" Interrupt any command running in the runner pane
map <Leader>rs :InterruptVimTmuxRunner<CR>

" abbrevations
iabbrev myAddr Pilestredet Park 20, 0176, Oslo , Norway

let $VIMHOME = $HOME."/.vim"


" templates
autocmd BufNewFile * silent! r $VIMHOME/templates/%:e.tpl
" jump to next placeholder with ctrl-j
nnoremap <c-j> /<+.\{-1,}+><cr>c/+>/e<cr>
inoremap <c-j> <ESC>/<+.\{-1,}+><cr>c/+>/e<cr>
match Todo /<+.\++>/

" moving text around
"CoffeeScript plugin settings
"ucomment to compile on write
"au BufWritePost *.coffee silent CoffeeMake!
