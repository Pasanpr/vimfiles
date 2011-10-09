set nocompatible                  " Must come first because it changes other options.

runtime! autoload/pathogen.vim
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

syntax enable                     " Turn on syntax highlighting.
filetype plugin indent on         " Turn on file type detection.

set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.

set backspace=indent,eol,start    " Intuitive backspacing.

set hidden                        " Handle multiple buffers better.

set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.

set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.

set number                        " Normal line number
set ruler                         " Show cursor position.

set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.

set nowrap                          " Turn on line wrapping.
set scrolloff=3                   " Show 3 lines of context around the cursor.
set textwidth=0
set colorcolumn=80

set list listchars=tab:\ \ ,trail:•

set visualbell                    " No beeping.

set nobackup                      " Don't make a backup before overwriting a file.
set nowritebackup                 " And again.
set directory=~/.vim/tmp,.  " Keep swap files in one location

set tabstop=2                     " Global tab width.
set shiftwidth=2                  " And again, related.
set expandtab                     " Use spaces instead of tabs

set cursorline

set title                         " Set the terminal's title

set gdefault                      " Default regexes to global
set laststatus=2


" Remaps

" Remap leader to ','
let mapleader=","

" Use 'jj' to exit insert mode
inoremap jj <ESC>l

" Shift-Enter to exit from insert mode
inoremap <S-CR> <Esc>l

" Use tab to jump between do/end etc.
nnoremap <tab> %
vnoremap <tab> %

" Quicker command mode
"nnoremap ; :

" Hit esc to clear search highlights
nnoremap <silent> <esc> :noh<return><esc>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer navigation
nnoremap <Leader>r <C-^>

" Remove trailing whitespace
nnoremap <Leader>w :%s/\s\+$//<CR>

" TextMate indentation
nmap <D-[> <<
nmap <D-]> >>
vmap <D-[> <gv
vmap <D-]> >gv

" Replace word with yanked word
nmap <Leader>p ciw<C-r>0<esc>

" Appearance

set background=dark
colorscheme ir_black

hi Cursor guibg=white
hi Visual guibg=#333333 guifg=#EEEEEE
hi ColorColumn guibg=#222222

" SignColumn
hi SignColumn term=standout ctermfg=11 ctermbg=8 guifg=Cyan guibg=#666666
hi Error term=reverse ctermfg=15 ctermbg=12 gui=none guifg=#f26168 guibg=black
hi WarningMsg term=standout ctermfg=15 ctermbg=12 gui=bold guifg=#ffe296 guibg=black

" NERDTree colors

autocmd VimEnter * hi NERDTreeDir guifg=#eeeeee gui=bold
autocmd VimEnter * hi NERDTreeDirSlash guifg=#eeeeee
autocmd VimEnter * hi NERDTreeExecFile gui=none


" Misc

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif

  " Thorfile, Rakefile, Vagrantfile, Prawn and Gemfile are Ruby
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru,*.prawn} set ft=ruby

  " Bones files are javscript
  au BufRead,BufNewFile {*.bones} set ft=javascript

  " Java
  au FileType java setlocal ts=4 sts=4 sw=4 expandtab
endif

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" NERDTree configuration
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
map <Leader>n :NERDTreeToggle<CR>
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1

" Command-T
let g:CommandTMaxHeight=20
let g:CommandTMatchWindowReverse=1

" RubyTest
map <Leader>s <Plug>RubyTestRun
map <Leader>S <Plug>RubyFileRun

