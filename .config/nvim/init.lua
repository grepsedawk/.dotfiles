local file = io.open(os.getenv("HOME") .. "/.vimrc", "r")
vim.cmd(file:read("*a"))
file:close()
