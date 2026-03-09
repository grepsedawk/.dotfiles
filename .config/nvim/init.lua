local file = io.open(os.getenv("HOME") .. "/.vimrc", "r")
vim.cmd(file:read("*a"))
file:close()

local use = require('packer').use
require('packer').startup(function()
  use 'github/copilot.vim'
  use 'wbthomason/packer.nvim'
  use {
    'autozimu/LanguageClient-neovim',
    branch = 'next',
    run = 'bash install.sh'
}
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

end)
