" turn off mouse mode
set mouse=c
" turn on spell checking
set spell

" tabs to 2 spaces
set expandtab
set shiftwidth=2
set softtabstop=2
filetype plugin indent on

" language specific, too
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=4 sts=4 sw=4

" live reload files if it changes on disk
set autoread
autocmd CursorHold * checktime

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

" fzf file fuzzy search that respects .gitignore
" Use :GFiles with these flags which essentially take any file that, is
" tracked, staged, or appears as untracked in `git status`, resulting in
" annoying directories like "deps" or "_build" being included in <C-p> results
" It will also include results that wouldn't otherwise have been included such
" as .circleci/config.yml
nnoremap <C-p> :GFiles --exclude-standard --others --cached<CR>

" ctags file setup
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" use control s to save and exit insert mode
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>

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
call plug#begin('~/.vim/plugged')
Plug 'w0rp/ale'
Plug 'christoomey/vim-tmux-navigator'

" Fuzzy searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Auto close "" () etc
Plug 'cohama/lexima.vim'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'janko-m/vim-test'
Plug 'sheerun/vim-polyglot'
Plug 'w0ng/vim-hybrid'

" Themes
Plug 'blueshirts/darcula'
Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'tpope/vim-surround'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-commentary'
Plug 'mhinz/vim-mix-format'

" ejs support
Plug 'nikvdp/ejs-syntax'

" Wakatime, a time spent coding tracker
Plug 'wakatime/vim-wakatime'
call plug#end()

" Theme
colorscheme dracula
highlight Normal ctermbg=None

let g:mix_format_on_save = 1

" custom leader commands
let mapleader = ","
" source vimrc
map <leader>so :source $MYVIMRC<CR>
map <Leader>vi :tabe ~/.vimrc<CR>
map <Esc><Esc> :noh<CR>:set nopaste<CR>
map <leader>r :!resize<CR><CR>
map <leader>f :set paste<CR>mmggi# frozen_string_literal: true<CR><CR><Esc>`m:set nopaste<CR>
map <leader>c :!ctags -R --languages=ruby --exclude=.git --exclude=log --tag-relative=yes . $(bundle list --paths)<CR>
map <leader>co mmgg"+yG`m
map <leader>' cs"'
map <leader>" cs'"
map <Leader>o :w<cr>:TestNearest<CR>

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
