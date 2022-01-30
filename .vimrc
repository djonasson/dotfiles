" vim: set foldmethod=marker foldmarker=, foldlevel=0

" Environment

  " Basics

    " The set nocompatible setting makes vim behave in a more useful way (the
    " default) than the vi-compatible manner. Remove the “no” to keep the
    " old vi behavior. Must be the first line since it changes other settings.
    set nocompatible

    " Assume a dark background
    set background=dark

    " Setup the mapleader. This is a variable that we can use when defining
    " shortcuts by inserting <leader>. It's a backslash by default but many
    " people prefer to change it to a comma that is more easily reached from
    " your default position.
    let mapleader = ","

  "

  " Setup Vundle (Vim bUNDLE) support
   let vundle_config = "~/.vimrc.vundle" "TODO: $XDG_CONFIG_HOME . '/vim/.vimrc.vundle'
   if filereadable(expand(vundle_config))
     exec "source " . vundle_config
   endif
  "

"


" General

  " allow to change buffers although the current one hasn't been saved
  set hidden

  " Stop vim from asking if you want to write the file before leaving buffer
  set autowrite

  " syntax highlight
  syntax on

  " always switch to the current file directory.
  "autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

  " have Q reformat the current paragraph (or selected text if there is any):
  nnoremap Q gqap
  vnoremap Q gq

  " Load matchit (% to bounce from do to end, etc.)
  runtime! macros/matchit.vim

  " 1000 undo levels
  set undolevels=1000

  " Remove trailing white-spaces with F5
  :nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

  " Make Y consistent with C and D (copy from cursor to the end of the line)
  nnoremap Y y$

  " ack-grep
  let g:ackprg="ack-grep -H --nocolor --nogroup --column"

  " Move current row up/down with Alt-k/Alt-j
  " Works both in normal and insert modes.
  nnoremap <A-j> :m+<CR>==
  nnoremap <A-k> :m-2<CR>==
  inoremap <A-j> <Esc>:m+<CR>==gi
  inoremap <A-k> <Esc>:m-2<CR>==gi
  vnoremap <A-j> :m'>+<CR>gv=gv
  vnoremap <A-k> :m-2<CR>gv=gv

  " Set 7 lines to the cursor - when moving vertically using j/k
  set so=7

  " Don't redraw while executing macros (good performance config)
  set lazyredraw
"



" Visual Improvements

  "Highlight trailing whitespace
  set list listchars=trail:.
  highlight SpecialKey ctermfg=DarkGray

  "Differentiate tabs from spaces
  set list listchars=tab:\|_,trail:.

  " Higlight current line
  " I've commented it out for the moment since it makes it noticeably slower
  " to move between lines.
  "set cursorline

  " show line numbers
  "set number

  " Remove the icon menu
  set guioptions-=T

  " Remove the main menu
  set guioptions-=m

  " Choose theme based upon terminal type
  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
    :silent! colorscheme railscasts
  else
    :silent! colorscheme desert
  endif

  " Set the default font
  set gfn=DejaVu\ Sans\ Mono\ 8

  " Commandline setup
    if has('cmdline_info')
      " show the ruler
      set ruler
      " a ruler on steroids
      set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
      " show partial commands in status line and selected characters/lines in visual mode
      set showcmd
    endif
  "

  " Statusline setup
    if has('statusline')
      set laststatus=2

      " Broken down into easily includeable segments
      " Filename
      set statusline=%<%f\
      " Options
      set statusline+=%w%h%m%r
      " Git
      set statusline+=%fugitive#statusline()
      " current dir
      set statusline+=\ %{getcwd()}
      " Right aligned file nav info
      set statusline+=%=%-14.(%l,%c%V%)\ %p%%
    endif
  "

"

" Searching
  " start searching immediately when using /something
  set sm

  " Incrementally jump to the search result
  set incsearch

  " Highlight search results
  set hlsearch

  " ignore case while searching
  set ignorecase
"

" Spell checking
  " Spell check when writing commit logs
  autocmd filetype svn,*commit* setlocal spell
"

" Tabs and Indentation
  " Wrap too long lines
  set wrap

  " Tabs are 2 characters
  set tabstop=2

  " (Auto)indent uses 2 characters
  set shiftwidth=2

  " spaces instead of tabs
  set expandtab

  " guess indentation
  set autoindent
"

" Key re-mappings

  " Code folding options
  nmap <leader>f0 :set foldlevel=0<CR>
  nmap <leader>f1 :set foldlevel=1<CR>
  nmap <leader>f2 :set foldlevel=2<CR>
  nmap <leader>f3 :set foldlevel=3<CR>
  nmap <leader>f4 :set foldlevel=4<CR>
  nmap <leader>f5 :set foldlevel=5<CR>
  nmap <leader>f6 :set foldlevel=6<CR>
  nmap <leader>f7 :set foldlevel=7<CR>
  nmap <leader>f8 :set foldlevel=8<CR>
  nmap <leader>f9 :set foldlevel=9<CR>

  " Clearing highlighted search
  nmap <silent> <leader>/ :nohlsearch<CR>

"

" Backup
  " We backup to the $XDG_CACHE_HOME/vim/backup and $XDG_CACHE_HOME/vim/tmp
  " folders instead of to the current directory.
  set backup
  function InitBackupDir()
    let parent = ($XDG_CACHE_HOME ?  $XDG_CACHE_HOME : '~/.cache') . '/vim'
    let backup = parent . '/backup/'
    let tmp    = parent . '/tmp/'
    if exists("*mkdir")
      if !isdirectory(parent)
        call mkdir(parent)
      endif
      if !isdirectory(backup)
        call mkdir(backup)
      endif
      if !isdirectory(tmp)
        call mkdir(tmp)
      endif
    endif
    let missing_dir = 0
    if isdirectory(tmp)
      execute 'set backupdir=' . escape(backup, " ") . "/,."
    else
      let missing_dir = 1
    endif
    if isdirectory(backup)
      execute 'set directory=' . escape(tmp, " ") . "/,."
    else
      let missing_dir = 1
    endif
    if missing_dir
      echo "Warning: Unable to create backup directories: " . backup ." and " . tmp
      echo "Try: mkdir -p " . backup
      echo "and: mkdir -p " . tmp
      set backupdir=.
      set directory=.
    endif
  endfunction
  call InitBackupDir()
"

" File handling and navigation

  " Expand the command line using tab
  set wildchar=<Tab>

  " show list instead of just completing
  set wildmenu

  " show matching files list when using :e etc. don't use greedy matching.
  set wildmode=longest,list

  " When editing a file, always jump to the last known cursor position. Don't
  " do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Let vim know that .prawn files are actually ruby files.
  au BufNewFile,BufRead *.prawn set filetype=ruby

"


" Use gvimrc if available and gui is running
  if has('gui_running')
    if filereadable(expand("~/.gvimrc"))
      source ~/.gvimrc
    endif
  endif
"
