-- Neovim settings converted from Lunar Vim
vim.opt.cmdheight = 2         -- more space in the neovim command line for displaying messages
vim.opt.guifont = "hack:h17"  -- the font used in graphical neovim applications
vim.opt.shiftwidth = 2        -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2           -- insert 2 spaces for a tab
vim.opt.relativenumber = true -- relative line numbers
vim.opt.wrap = true           -- wrap lines
vim.opt.number = true         -- show line numbers
vim.opt.expandtab = true      -- convert tabs to spaces
vim.opt.smartindent = true    -- make indenting smarter again
vim.opt.undofile = true       -- enable persistent undo
vim.opt.updatetime = 500      -- faster completion (4000ms default)
vim.opt.timeoutlen = 1000     -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.backup = false        -- creates a backup file
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.conceallevel = 0      -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.hlsearch = true       -- highlight all matches on previous search pattern
vim.opt.ignorecase = true     -- ignore case in search patterns
vim.opt.mouse = "a"           -- allow the mouse to be used in neovim
vim.opt.pumheight = 10        -- pop up menu height
vim.opt.showmode = false      -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 2       -- always show tabs
vim.opt.smartcase = true      -- smart case
vim.opt.splitbelow = true     -- force all horizontal splits to go below current window
vim.opt.splitright = true     -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false      -- creates a swapfile
vim.opt.termguicolors = true  -- set term gui colors (most terminals support this)
vim.opt.writebackup = false   -- if a file is being edited by another program it is not allowed to be edited
vim.opt.cursorline = true     -- highlight the current line
vim.opt.signcolumn = "yes"    -- always show the sign column, otherwise it would shift the text each time
vim.opt.scrolloff = 8         -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8     -- minimal number of screen columns either side of cursor if wrap is `false`

-- Highlight groups for cursors
vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#44475a", bold = true })
vim.api.nvim_set_hl(0, "iCursor", { fg = "#000000", bg = "#6272a4", bold = true })
vim.api.nvim_set_hl(0, "vCursor", { fg = "#000000", bg = "#555555", bold = true })
vim.api.nvim_set_hl(0, "rCursor", { fg = "#000000", bg = "#888888", bold = true })

-- WSL-specific optimizations
vim.opt.shell = "/bin/bash"
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

-- Faster file watching
vim.opt.updatetime = 300
