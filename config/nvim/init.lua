vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.termguicolors = true
vim.opt.updatetime = 250

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazy_path) then
  local result = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazy_path,
  })

  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim:\n" .. result)
  end
end

vim.opt.rtp:prepend(lazy_path)

require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})

vim.cmd.colorscheme("mothline")
