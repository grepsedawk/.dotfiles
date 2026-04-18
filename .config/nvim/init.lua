local file = io.open(os.getenv("HOME") .. "/.vimrc", "r")
vim.cmd(file:read("*a"))
file:close()

local use = require('packer').use
require('packer').startup(function()
  use 'github/copilot.vim'
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-abolish' -- TODO: learn

  use 'christoomey/vim-tmux-navigator'
  use 'sheerun/vim-polyglot'
  use 'jlcrochet/vim-crystal'
  use 'w0rp/ale'
  use { 'junegunn/fzf', run = 'cd ~/.fzf && ./install --all' }
  use 'junegunn/fzf.vim'

  -- Crystal LSP — ships its own plugin/ + lua/ glue, builds the binary
  -- on install, registers itself with native LSP.
  use {
    'grepsedawk/crystal-language-server',
    run = 'shards build --release --no-debug',
    ft  = 'crystal',
  }

end)

-- Handy keymaps, scoped to buffers that have an LSP attached. These use
-- the same names Telescope/trouble users are used to so the muscle
-- memory carries over.
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
  end,
})
