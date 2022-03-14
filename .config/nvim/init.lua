local file = io.open(os.getenv("HOME") .. "/.vimrc", "r")
vim.cmd(file:read("*a"))
file:close()

local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  -- use 'neovim/nvim-lspconfig'
  -- require'lspconfig'.crystalline.setup{}

  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-abolish' -- TODO: learn

  use 'christoomey/vim-tmux-navigator'
  use 'sheerun/vim-polyglot' -- TODO: Is this not working? Had to add vim-crystal below
  use 'w0rp/ale'
  use { 'junegunn/fzf', run = 'cd ~/.fzf && ./install --all' }
  use 'junegunn/fzf.vim'

  use 'vim-crystal/vim-crystal'

  use 'github/copilot.vim'

  use 'wakatime/vim-wakatime'
end)
