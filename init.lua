-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load settings
require("config.settings")

-- Load key mappings
require("config.keymaps")

-- Load plugins with lazy.nvim
require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})

-- GLSL file type detection
vim.filetype.add({
  extension = {
    vert = "glsl",
    frag = "glsl",
  },
})
