set guifont=Inconsolata\ XL:h12       " Font family and font size.
set antialias                     " MacVim: smooth fonts.
set encoding=utf-8                " Use UTF-8 everywhere.
set guioptions-=T                 " Hide toolbar.
set guioptions-=L
set guioptions-=r                 " Don't show right scrollbar

if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert

  " Command-/ to toggle comments
  map <D-/> <plug>NERDCommenterToggle<CR>
  imap <D-/> <Esc><plug>NERDCommenterToggle<CR>i

  " Command-Option-ArrowKey to switch viewports
  map <D-M-Up> <C-w>k
  imap <D-M-Up> <Esc> <C-w>k
  map <D-M-Down> <C-w>j
  imap <D-M-Down> <Esc> <C-w>j
  map <D-M-Right> <C-w>l
  imap <D-M-Right> <Esc> <C-w>l
  map <D-M-Left> <C-w>h
  imap <D-M-Left> <C-w>h

  " Adjust viewports to the same size
  map <Leader>= <C-w>=
  imap <Leader>= <Esc> <C-w>=

  imap <C-tab> <C-x><C-u>
endif

" Below is mostly NERDTree related and was taken from Janus (github.com/carlhuda/janus)

" Utility functions to create file commands
function s:CommandCabbr(abbreviation, expansion)
  execute 'cabbrev ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction

function s:FileCommand(name, ...)
  if exists("a:1")
    let funcname = a:1
  else
    let funcname = a:name
  endif

  execute 'command -nargs=1 -complete=file ' . a:name . ' :call ' . funcname . '(<f-args>)'
endfunction

function s:DefineCommand(name, destination)
  call s:FileCommand(a:destination)
  call s:CommandCabbr(a:name, a:destination)
endfunction

" Project Tree
autocmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))
autocmd FocusGained * call s:UpdateNERDTree()
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" If the parameter is a directory, cd into it
function s:CdIfDirectory(directory)
  let explicitDirectory = isdirectory(a:directory)
  let directory = explicitDirectory || empty(a:directory)

  if explicitDirectory
    exe "cd " . fnameescape(a:directory)
  endif

  " Allows reading from stdin
  " ex: git diff | mvim -R -
  if strlen(a:directory) == 0
    return
  endif

  if directory
    NERDTree
    wincmd p
    bd
  endif

  if explicitDirectory
    wincmd p
  endif
endfunction

" NERDTree utility function
function s:UpdateNERDTree(...)
  let stay = 0

  if(exists("a:1"))
    let stay = a:1
  end

  if exists("t:NERDTreeBufName")
    let nr = bufwinnr(t:NERDTreeBufName)
    if nr != -1
      exe nr . "wincmd w"
      exe substitute(mapcheck("R"), "<CR>", "", "")
      if !stay
        wincmd p
      end
    endif
  endif

  if exists(":CommandTFlush") == 2
    CommandTFlush
  endif
endfunction

" Public NERDTree-aware versions of builtin functions
function ChangeDirectory(dir, ...)
  execute "cd " . fnameescape(a:dir)
  let stay = exists("a:1") ? a:1 : 1

  NERDTree

  if !stay
    wincmd p
  endif
endfunction

function Touch(file)
  execute "!touch " . shellescape(a:file, 1)
  call s:UpdateNERDTree()
endfunction

function Remove(file)
  let current_path = expand("%")
  let removed_path = fnamemodify(a:file, ":p")

  if (current_path == removed_path) && (getbufvar("%", "&modified"))
    echo "You are trying to remove the file you are editing. Please close the buffer first."
  else
    execute "!rm " . shellescape(a:file, 1)
  endif

  call s:UpdateNERDTree()
endfunction

function Mkdir(file)
  execute "!mkdir " . shellescape(a:file, 1)
  call s:UpdateNERDTree()
endfunction

function Edit(file)
  if exists("b:NERDTreeRoot")
    wincmd p
  endif

  execute "e " . fnameescape(a:file)

ruby << RUBY
  destination = File.expand_path(VIM.evaluate(%{system("dirname " . shellescape(a:file, 1))}))
  pwd         = File.expand_path(Dir.pwd)
  home        = pwd == File.expand_path("~")

  if home || Regexp.new("^" + Regexp.escape(pwd)) !~ destination
    VIM.command(%{call ChangeDirectory(fnamemodify(a:file, ":h"), 0)})
  end
RUBY
endfunction

" Define the NERDTree-aware aliases
call s:DefineCommand("cd", "ChangeDirectory")
call s:DefineCommand("touch", "Touch")
call s:DefineCommand("rm", "Remove")
call s:DefineCommand("e", "Edit")
call s:DefineCommand("mkdir", "Mkdir")

let NERDTreeShowHidden=1

nnoremap <Leader>jc :JavaCorrect<CR>
nnoremap <Leader>jim :JavaImportMissing<CR>
nnoremap <Leader>jic :JavaImportClean<CR>

