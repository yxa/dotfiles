call pathogen#infect()
syntax on
filetype plugin indent on

set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

set backspace=indent,eol,start
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

autocmd BufWritePre * :%s/\s\+$//e
hi Visual  guifg=White guibg=LightBlue gui=none

" show and hide invisible charactes
nmap <F3> :set list!<CR>

set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,nbsp:_
highlight SpecialKey term=standout ctermbg=yellow guibg=yellow


" Highlight the selected entry in the tree
let NERDTreeHighlightCursorline=1
let NERDTreeShowHidden=1
autocmd VimEnter * NERDTree
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction


set runtimepath^=~/.vim/bundle/ctrlp.vim
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|node_modules)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" Use a single click to fold/unfold directories and a double click to open
let NERDTreeMouseMode=2

map <F2> :NERDTreeToggle<CR>

let g:NERDTreeDirArrows=0

" Store the bookmarks file
let NERDTreeBookmarksFile=expand("$HOME/.vim/NERDTreeBookmarks")

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1
let g:NERDTreeWinSize = 50

let NERDTreeIgnore = ['\.svn$']

set backupdir=~/vimtmp,.
set directory=~/vimtmp,.

let mapleader = ","

" Softtabs, 2 spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

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

" enable and disable highlightning
:set hlsearch
:noremap <F6> :set hlsearch! hlsearch?<CR>

let $VIMHOME = $HOME."/.vim"


" templates
autocmd BufNewFile * silent! r $VIMHOME/templates/%:e.tpl
" jump to next placeholder with ctrl-j
nnoremap <c-j> /<+.\{-1,}+><cr>c/+>/e<cr>
inoremap <c-j> <ESC>/<+.\{-1,}+><cr>c/+>/e<cr>
match Todo /<+.\++>/

autocmd BufReadPre *.js let b:javascript_lib_use_jquery = 1
autocmd BufReadPre *.js let b:javascript_lib_use_underscore = 1
autocmd BufReadPre *.js let b:javascript_lib_use_backbone = 1

let jshint2_save = 1

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

" formatting settings
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
