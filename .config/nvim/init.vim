" Make the leader key Space
let g:mapleader = "\<Space>"

" Autoinstall vim-plug
if empty(glob('~/.nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" -----------------------------------------------------------------------------
" Plugins
" -----------------------------------------------------------------------------

" Specify a directory for plugins.
call plug#begin('~/.config/nvim/plugged')

" Intellisense Engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" {{{
  let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-pairs',
    \ 'coc-tsserver',
    \ 'coc-eslint',
    \ 'coc-prettier',
    \ 'coc-json',
    \ 'coc-yaml',
    \ ]
  set hidden
  set updatetime=300
  set shortmess+=c
  set signcolumn=yes

  " Use tab for trigger completion with characters ahead and navigate.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  " Or use `complete_info` if your vim support it, like:
  " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use `[g` and `]g` to navigate diagnostics
  " nmap <silent> [g <Plug>(coc-diagnostic-prev)
  " nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
" }}}

" SLS code formatting
Plug 'saltstack/salt-vim'

" Atom One Dark theme.
Plug 'joshdick/onedark.vim'

" Shades of Purple theme (similar to VSCode)
Plug 'Rigellute/shades-of-purple.vim'

"Pass focus events from tmux to Vim (useful for autoread and linting tools).
Plug 'tmux-plugins/vim-tmux-focus-events'

" Helpers for moving and manipulating files / directories.
Plug 'tpope/vim-eunuch'

" Briefly highlight which text was yanked.
Plug 'machakann/vim-highlightedyank'

" Highlight which character to jump to when using horizontal movement keys.
Plug 'unblevable/quick-scope'

" Automatically clear search highlights after you move your cursor.
Plug 'haya14busa/is.vim'

" Better display unwanted whitespace.
Plug 'ntpeters/vim-better-whitespace'

" Toggle comments in various ways.
Plug 'tpope/vim-commentary'

" Automatically set 'shiftwidth' + 'expandtab' (indention) based on file type.
Plug 'tpope/vim-sleuth'

" Show git file changes in the gutter.
Plug 'mhinz/vim-signify'

" A git wrapper.
Plug 'tpope/vim-fugitive'

" Enables :Gbrowse to open GitHub URLs
Plug 'tpope/vim-rhubarb'

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" Distraction free writing by removing UI elements and centering everything.
Plug 'junegunn/goyo.vim'
" {{{
  let g:goyo_width = 120

  " Open Goyo using leader+z
  nnoremap <silent> <expr> <leader>z (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Goyo<cr>"
" }}}

" NERDTree - file system explorer
Plug 'preservim/nerdtree'
" {{{
  " Make NERDTree look a little nicer
  let NERDTreeMinimalUI = 1
  let NERDTreeDirArrows = 1

  " Delete the buffer of the file just deleted with NERDTree
  let NERDTreeAutoDeleteBuffer = 1

  " Hide specific files/directories
  let NERDTreeIgnore = ['\.pyc$', '__pycache__', '__pycache__']

  " Toggle NERDTree with CTRL+n
  map <C-n> :NERDTreeToggle<CR>

  " Find current file in NERDTree window
  map <leader>e :NERDTreeFind<cr>
" }}}

" For NERDTree - shows git status flags
Plug 'Xuyuanp/nerdtree-git-plugin'

" A general purpose fuzzy file finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" {{{
  let g:fzf_nvim_statusline = 0 " disable statusline overwriting

  nnoremap <silent> <expr> <leader><leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":GFiles --cached --others --exclude-standard<cr>"
  nnoremap <silent> <expr> <leader>a (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Buffers<cr>"
  nnoremap <silent> <expr> <leader>A (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Windows<cr>"
  nnoremap <silent> <expr> <leader>f (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Ag<cr>"
  nnoremap <silent> <leader>? :History<CR>
  nnoremap <silent> <leader>gl :Commits<CR>
  nnoremap <silent> <leader>ga :BCommits<CR>

  imap <C-x><C-f> <plug>(fzf-complete-file-ag)
  imap <C-x><C-l> <plug>(fzf-complete-line)

  let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-y': {lines -> setreg('*', join(lines, "\n"))}}
" }}}

Plug 'davidhalter/jedi-vim'

call plug#end()

" -----------------------------------------------------------------------------
" Color settings
" -----------------------------------------------------------------------------

" Enable 24-bit true colors if your terminal supports it.
if (has("termguicolors"))
  " https://github.com/vim/vim/issues/993#issuecomment-255651605
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  set termguicolors
endif

" Enable syntax highlighting.
syntax on

" Set the color scheme.
colorscheme shades_of_purple

" Set the color scheme to dark.
set background=dark


" -----------------------------------------------------------------------------
" Status line
" -----------------------------------------------------------------------------

" Heavily inspired by: https://github.com/junegunn/dotfiles/blob/master/vimrc
function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'

  return '[%n] %f %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction

let &statusline = s:statusline_expr()

" -----------------------------------------------------------------------------
" Basic Settings
" -----------------------------------------------------------------------------

set autoindent
set autoread
set backspace=indent,eol,start
set backupdir=/tmp//,.
set clipboard=unnamedplus
set complete+=kspell
" set completeopt=menuone,longest
set cursorline
set directory=/tmp//,.
set encoding=utf-8
set expandtab smarttab
set formatoptions=tcqrn1
set guifont=Inconsolata\ Medium\ 12 linespace=0
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set matchpairs+=<:> " Use % to jump between pairs
set mmp=5000
set modelines=2
set mouse=a
set nocompatible
set noerrorbells visualbell t_vb=
set noshiftround
set nospell
set nostartofline
set number relativenumber
set regexpengine=1
set ruler
set scrolloff=3
set shiftwidth=2
set showcmd
set showmatch
set shortmess+=c
set showmode
set smartcase
set softtabstop=2
set spelllang=en_us
set splitbelow
set splitright
set tabstop=2
set textwidth=0
set ttimeout
set ttyfast
set undodir=/tmp
set undofile
set virtualedit=block
set whichwrap=b,s,<,>
set wildmenu
set wildmode=full
set wrap

" -----------------------------------------------------------------------------
" Basic mappings
" -----------------------------------------------------------------------------
"
nnoremap <leader>cf :let @*=fnamemodify(expand("%"), ":~:.")<CR>

" Navigate around splits with a single key combo.
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-j> <C-w><C-j>

" Cycle through splits.
nnoremap <S-Tab> <C-w>w

" Prevent x from overriding what's in the clipboard.
noremap x "_x
noremap X "_x

" Prevent selecting and pasting from overwriting what you originally copied.
xnoremap p pgvy

" Keep cursor at the bottom of the visual selection after you yank it.
vmap y ygv<Esc>

" Source Vim config file.
map <Leader>sv :source $MYVIMRC<CR>

" -----------------------------------------------------------------------------
" Basic autocommands
" -----------------------------------------------------------------------------

" Auto-resize splits when Vim gets resized.
autocmd VimResized * wincmd =

" Update a buffer's contents on focus if it changed outside of Vim.
au FocusGained,BufEnter * :checktime

" Unset paste on InsertLeave.
autocmd InsertLeave * silent! set nopaste

" Make sure all types of requirements.txt files get syntax highlighting.
autocmd BufNewFile,BufRead requirements*.txt set syntax=python

" Ensure tabs don't get converted to spaces in Makefiles.
autocmd FileType make setlocal noexpandtab

" Only show the cursor line in the active buffer.
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" Open NERDTree if no file was specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NERDTree if only a directory was specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" Close vim if the only window left is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
