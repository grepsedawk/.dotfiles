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
vim.opt.termguicolors  = true

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
-- Let nvim-cmp / LSP own these languages — ALE still handles linting/fixing.
vim.g.ale_disable_lsp = 1

--------------------------------------------------------------------------------
-- Bootstrap lazy.nvim
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
require("lazy").setup({
  -- theme: dracula_pro is a paid theme shipped in-tree at
  -- pack/themes/start/dracula_pro. Lazy manages runtimepath, so we
  -- point it at that directory and load first (priority=1000).
  {
    dir      = vim.fn.stdpath("config") .. "/pack/themes/start/dracula_pro",
    name     = "dracula_pro",
    lazy     = false,
    priority = 1000,
    config   = function()
      vim.cmd.colorscheme("dracula_pro_buffy")
      vim.cmd("highlight Normal ctermbg=None")
    end,
  },

  -- editing
  "tpope/vim-commentary",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "tpope/vim-abolish", -- TODO: learn

  -- git
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", opts = {} },
  "tpope/vim-fugitive",

  -- navigation
  "christoomey/vim-tmux-navigator",
  { "junegunn/fzf", build = "cd ~/.fzf && ./install --all" },
  "junegunn/fzf.vim",

  -- telescope: fuzzy everything (grep, buffers, symbols, diagnostics, help)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>sg", function() require("telescope.builtin").live_grep() end,             desc = "Telescope: grep" },
      { "<leader>sb", function() require("telescope.builtin").buffers() end,               desc = "Telescope: buffers" },
      { "<leader>sh", function() require("telescope.builtin").help_tags() end,             desc = "Telescope: help" },
      { "<leader>ss", function() require("telescope.builtin").lsp_document_symbols() end,  desc = "Telescope: doc symbols" },
      { "<leader>sd", function() require("telescope.builtin").diagnostics() end,           desc = "Telescope: diagnostics" },
      { "<leader>sr", function() require("telescope.builtin").resume() end,                desc = "Telescope: resume" },
    },
  },

  -- treesitter: AST-accurate highlight, indent, folds. The main branch
  -- exposes an async install() + per-filetype vim.treesitter.start()
  -- instead of the old configs.setup API.
  {
    "nvim-treesitter/nvim-treesitter",
    lazy  = false, -- main branch doesn't support lazy-loading
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "lua", "vim", "vimdoc", "bash",
        "json", "yaml", "toml",
        "ruby", "go", "python",
        "javascript", "typescript", "tsx", "html", "css",
        "markdown", "markdown_inline", "gitcommit", "diff",
      }
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
          vim.wo.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- LSP: mason installs servers, lspconfig wires them up
  { "williamboman/mason.nvim",           opts = {} },
  { "williamboman/mason-lspconfig.nvim", opts = { ensure_installed = { "lua_ls" } } },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- nvim 0.11+ LSP API. nvim-lspconfig supplies default configs per
      -- server; we layer cmp capabilities on top and enable what we want.
      local caps = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = caps })
      vim.lsp.enable({ "lua_ls" })
    end,
  },

  -- Crystal LSP — ships its own plugin/ + lspconfig glue, builds its own
  -- binary via shards on install.
  {
    "grepsedawk/crystal-language-server",
    build = "shards build --release --no-debug",
    ft    = "crystal",
  },

  -- completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip"  },
          { name = "buffer"   },
          { name = "path"     },
        }),
        -- Copilot owns <Tab>, so cmp uses <C-n>/<C-p>/<CR> instead.
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),
        }),
      })
    end,
  },

  -- discoverability: shows what's bound after you press <leader>
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- language support (filetype detect + legacy syntax for things
  -- treesitter doesn't cover)
  "sheerun/vim-polyglot",
  "jlcrochet/vim-crystal",

  -- linting + formatting (on-save fixers)
  "w0rp/ale",

  -- AI
  "github/copilot.vim",
}, {
  -- lazy.nvim itself
  install = { colorscheme = { "dracula_pro_buffy", "habamax" } },
  change_detection = { notify = false },
})

--------------------------------------------------------------------------------
-- Mappings, autocmds, and the RenameFile function — kept as vimscript on
-- purpose. The Lua equivalents add boilerplate without much clarity.
--
-- Note: <C-p> (fzf) conflicts with cmp's prev-item binding, but cmp only
-- owns it inside insert-mode completion menus, so normal-mode <C-p>
-- still opens fzf.
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
