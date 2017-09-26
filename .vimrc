" turn off mouse mode
set mouse=c

" tabs to 2 spaces
set expandtab
set shiftwidth=2
set softtabstop=2
filetype plugin indent on

" word wrap more excellently
nmap k gk
nmap j gj

" relative line numbers
set relativenumber 
set number

" search options
set incsearch
set hlsearch
set ignorecase
set smartcase

" fzf file fuzzy search
nnoremap <C-p> :FZF<CR>

" ag searching
let g:ackprg = 'ag --vimgrep --smart-case'                                                   
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack

" ctags file setup
set tags=./.tags;/
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" use control s to save and exit insert mode
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>:!ctags -R -f .tags .<CR><CR>

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
call plug#begin('~/.local/share/nvim/plugged')

Plug 'w0rp/ale'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'sheerun/vim-polyglot'
Plug 'w0ng/vim-hybrid'
Plug 'blueshirts/darcula'
Plug 'tmhedberg/matchit'
Plug 'joker1007/vim-ruby-heredoc-syntax'

call plug#end()

" Theme
colorscheme hybrid

" custom leader commands
let mapleader = ","
" source vimrc
nmap <leader>so :source $MYVIMRC<CR>
nmap <Esc><Esc> :noh<CR>:set nopaste<CR>
nmap <leader>r :!resize<CR><CR>
nmap <leader>f :set paste<CR>mmggi# frozen_string_literal: true<CR><CR><Esc>`m:set nopaste<CR>
nmap <leader>c :!ctags -R -f .tags .<CR>
