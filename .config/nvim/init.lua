local file = io.open(os.getenv("HOME") .. "/.vimrc", "r")
vim.cmd(file:read("*a"))
file:close()

local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  -- use 'neovim/nvim-lspconfig'
  -- require'lspconfig'.crystalline.setup{}

  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-commentary'
  use 'sheerun/vim-polyglot'
  use 'w0rp/ale'
  use { 'junegunn/fzf', run = 'cd ~/.fzf && ./install --all' }
  use 'junegunn/fzf.vim'

  use 'vim-crystal/vim-crystal'
end)
