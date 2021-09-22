" turn off mouse mode
set mouse=c
" turn on spell checking
set spell

" tabs to 2 spaces
set expandtab
set shiftwidth=2
set softtabstop=2
filetype plugin indent on

" Add a line at col 80
set colorcolumn=80

" language specific tabbing
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=4 sts=4 sw=4
autocmd Filetype qf nnoremap <buffer> q :q<CR>

" set default dispatch commands per file
autocmd FileType sh let b:dispatch = './%'

" live reload files if it changes on disk
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * checktime
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" word wrap more excellently
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" relative line numbers
set relativenumber 
set number

" search options
set incsearch
set hlsearch
set ignorecase
set smartcase
set gdefault " replace option

" fzf file fuzzy search that respects .gitignore
" If in git directory, show only files that are committed, staged, or unstaged
" else use regular :Files
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"
" TODO: Directory edit for file creation (maybe even inc mkdir -p)
" nnoremap <expr> <C-S-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"

" ctags file setup
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" use control s to save and exit insert mode
noremap <silent> <C-s> :update<CR>:Dispatch! git rev-parse && git ls-files \| ctags -L -<CR>:noh<CR>:set nopaste<CR>
inoremap <silent> <C-s> <C-c>:update<CR>:Dispatch! git rev-parse && git ls-files \| ctags -L -<CR>:noh<CR>:set nopaste<CR>

" additional escapes
imap jk <esc>
imap kj <esc>

" open panes same location as tmux
set splitbelow
set splitright

" stop using arrow keys, dammit
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" Plugins!
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'w0rp/ale'

Plug 'christoomey/vim-tmux-navigator'

" Fuzzy searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Background processes made easy
Plug 'tpope/vim-dispatch'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'vim-ruby/vim-ruby'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-rails'
Plug 'sheerun/vim-polyglot'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Themes
Plug 'blueshirts/darcula'
Plug 'dracula/vim', { 'as': 'dracula' }

" Colorize hex color strings
Plug 'chrisbra/Colorizer'

Plug 'tpope/vim-surround'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-commentary'
Plug 'mhinz/vim-mix-format'

" ejs support
Plug 'nikvdp/ejs-syntax'

" HTML support
Plug 'mattn/emmet-vim'

" Wakatime, a time spent coding tracker
Plug 'wakatime/vim-wakatime'

" hardmode
Plug 'takac/vim-hardtime'
" let g:hardtime_default_on = 1

Plug 'tpope/vim-endwise'
call plug#end()

" Theme
packadd! dracula_pro
" syntax enable
let g:dracula_colorterm = 0
colorscheme dracula_pro
" set background=dark
" colorscheme darcula
highlight Normal ctermbg=None

" Plugin Configs
let g:mix_format_on_save = 1

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'ruby': ['rubocop'],
      \ 'terraform': ['terraform'],
      \ }

let g:splitjoin_ruby_hanging_args = 0

" custom leader commands
let mapleader = ","
" source vimrc
map <leader>so :source $MYVIMRC<CR>
map <Leader>vi :tabe ~/.vimrc<CR>
map <Leader>vn :tabe notes.md<CR>
map <leader>r :!resize<CR><CR>
map <leader>f :ALEFix<CR>
map <leader>co mmgg"+yG`m
map <leader>' cs"'
map <leader>" cs'"
map <Leader>o :Dispatch<cr>
map <Leader>q @q
map <Leader>t :Tags<cr>
map <leader>g :Git 

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <Leader>n :call RenameFile()<cr>
