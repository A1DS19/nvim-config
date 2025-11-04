-- Key mappings converted from Lunar Vim
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General Key Mappings
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)
keymap("n", "<leader>bd", "<cmd>bd<CR>", opts)
keymap("n", "<leader>bn", "<cmd>bn<CR>", opts)
keymap("n", "<leader>bp", "<cmd>bp<CR>", opts)

-- Grep in current file
keymap("n", "<leader>fgf", function()
  require('telescope.builtin').live_grep({
    search_dirs = { vim.fn.expand('%:p') }
  })
end, opts)

-- File Browser
keymap("n", "<leader>e", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", opts)

-- Session Management
keymap("n", "<leader>ss", "<cmd>lua require('persistence').save()<CR>", opts)
keymap("n", "<leader>sr", "<cmd>lua require('persistence').load()<CR>", opts)
keymap("n", "<leader>sn", "<cmd>lua require('persistence').stop()<CR>", opts)
keymap("n", "<leader>sl", "<cmd>lua require('persistence').load({ last = true })<CR>", opts)
keymap("n", "<leader>sa", "<cmd>lua save_session_with_name()<CR>", opts)

-- Custom function to save session with a name
function save_session_with_name()
  local session_name = vim.fn.input("Session Name: ")
  if session_name ~= "" then
    require("persistence").save(session_name)
  else
    print("Session name cannot be empty!")
  end
end

-- NvimTree mappings
keymap("n", "<C-t>", ":NvimTreeToggle<CR>", opts)

-- LSP mappings
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

-- Diagnostic keymaps
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)
keymap("n", "<leader>d", vim.diagnostic.open_float, opts)
keymap("n", "<leader>q", vim.diagnostic.setloclist, opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal
keymap("n", "<leader>tt", "<cmd>ToggleTerm<CR>", opts)

-- Format on save autocmd
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {
    "*.rs", "*.c", "*.cpp", "*.cs", "*.ts", "*.tsx", "*.js", "*.jsx", "*.py", "*.lua", "*.hpp", "*.h",
    "*.json",
    "*.yaml", "*.yml",
    "*.toml",
    "*.sh", "*.bash",
    "*.html",
    "*.css", "*.scss",
    "*.md",
    "*.cmake",
    "CMakeLists.txt",
    "Makefile",
    "*.make",
    "Dockerfile",
    "*.dockerfile",
    "*.go",
    "*.java",
    "*.php",
    "*.rb",
    "*.vim",
    "*.xml",
    "*.svg",
    "*.vert",
    "*.frag",
    "*.glsl"
  },
  callback = function()
    vim.lsp.buf.format({ async = false })
    print("File formatted and saved!")
  end,
})
