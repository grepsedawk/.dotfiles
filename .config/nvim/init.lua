--------------------------------------------------------------------------------
-- Leader (must be set before any mapping references <leader>)
--------------------------------------------------------------------------------
vim.g.mapleader = ","

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------
vim.opt.mouse          = "c"
vim.opt.spell          = true
vim.opt.colorcolumn    = "80"
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.autoread       = true

-- search
vim.opt.incsearch  = true
vim.opt.hlsearch   = true
vim.opt.ignorecase = true
vim.opt.smartcase  = true
vim.opt.gdefault   = true -- :s replaces all matches on a line by default

-- splits open where tmux does
vim.opt.splitbelow = true
vim.opt.splitright = true

--------------------------------------------------------------------------------
-- Plugin globals (must be set before the plugin loads)
--------------------------------------------------------------------------------
vim.g.dracula_colorterm           = 0
vim.g.splitjoin_ruby_hanging_args = 0

vim.g.ale_fix_on_save = 1
vim.g.ale_fixers = {
  ["*"]      = { "remove_trailing_lines", "trim_whitespace" },
  ruby       = { "rubocop" },
  terraform  = { "terraform" },
  crystal    = { "crystal" },
  css        = { "prettier" },
  javascript = { "prettier" },
  typescript = { "prettier" },
}

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- editing
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-abolish' -- TODO: learn

  -- git
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-fugitive'

  -- navigation
  use 'christoomey/vim-tmux-navigator'
  use { 'junegunn/fzf', run = 'cd ~/.fzf && ./install --all' }
  use 'junegunn/fzf.vim'

  -- language support
  use 'sheerun/vim-polyglot'
  use 'jlcrochet/vim-crystal'
  use 'w0rp/ale'

  -- Crystal LSP — ships its own plugin/ + lua/ glue, builds the binary
  -- on install, registers itself with native LSP.
  use {
    'grepsedawk/crystal-language-server',
    run = 'shards build --release --no-debug',
    ft  = 'crystal',
  }

  -- AI
  use 'github/copilot.vim'
end)

--------------------------------------------------------------------------------
-- Theme
--------------------------------------------------------------------------------
vim.cmd("packadd! dracula_pro")
vim.cmd.colorscheme("dracula_pro_buffy")
vim.cmd("highlight Normal ctermbg=None")

--------------------------------------------------------------------------------
-- Mappings, autocmds, and the RenameFile function — kept as vimscript on
-- purpose. The Lua equivalents add boilerplate without much clarity.
--------------------------------------------------------------------------------
vim.cmd([[
" language-specific tabbing
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype qf nnoremap <buffer> q :q<CR>

" default :Dispatch command per filetype
autocmd FileType sh let b:dispatch = './%'

" reload buffer when the file changes on disk
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * checktime
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" word wrap more excellently
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" fzf file fuzzy search that respects .gitignore.
" In a git directory show committed/staged/unstaged files; else :Files.
" TODO: Directory edit for file creation (maybe even inc mkdir -p)
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"

" ctags
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" ctrl-s: save, clear search highlight, leave paste mode
noremap  <silent> <C-s> :update<CR>:noh<CR>:set nopaste<CR>
inoremap <silent> <C-s> <C-c>:update<CR>:noh<CR>:set nopaste<CR>

" additional escapes
imap jk <esc>
imap kj <esc>

" stop using arrow keys, dammit
noremap  <Up>    <nop>
noremap  <Down>  <nop>
noremap  <Left>  <nop>
noremap  <Right> <nop>
inoremap <Up>    <nop>
inoremap <Down>  <nop>
inoremap <Left>  <nop>
inoremap <Right> <nop>

" leader commands
map <leader>so :source $MYVIMRC<CR>
map <leader>vi :tabe ~/.config/nvim/init.lua<CR>
map <leader>vn :tabe notes.md<CR>
map <leader>r  :!resize<CR><CR>
map <leader>co mmgg"+yG`m
map <leader>'  cs"'
map <leader>"  cs'"
map <leader>o  :Dispatch<cr>
map <leader>q  @q
map <leader>t  :Tags<cr>
map <leader>a  :Ag<cr>
map <leader>g  :Git
map <leader>n  :call RenameFile()<cr>

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
]])

--------------------------------------------------------------------------------
-- LSP keymaps (buffer-local, fire on attach). Names match the
-- Telescope/trouble defaults so the muscle memory carries over.
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local buf = args.buf
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = buf, silent = true, desc = desc })
    end
    map('K',          vim.lsp.buf.hover,          'LSP: hover')
    map('gd',         vim.lsp.buf.definition,     'LSP: go to definition')
    map('gr',         vim.lsp.buf.references,     'LSP: references')
    map('<leader>rn', vim.lsp.buf.rename,         'LSP: rename')
    map('<leader>ca', vim.lsp.buf.code_action,    'LSP: code action')
    map('<leader>f',  function() vim.lsp.buf.format({ async = true }) end, 'LSP: format')
    map('[d',         vim.diagnostic.goto_prev,   'LSP: prev diagnostic')
    map(']d',         vim.diagnostic.goto_next,   'LSP: next diagnostic')

    -- Inlay hints (nvim 0.10+). Enabled per-buffer on attach; toggle
    -- with <leader>ih if the ghost text gets noisy.
    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
      map('<leader>ih', function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }),
          { bufnr = buf }
        )
      end, 'LSP: toggle inlay hints')
    end
  end,
})
