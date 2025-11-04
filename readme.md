# Neovim Configuration Setup Guide

This repository contains a complete Neovim configuration converted from Lunar Vim, featuring LSP, autocompletion, debugging, and more.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Linux/macOS](#linuxmacos)
  - [Windows (WSL)](#windows-wsl)
  - [Windows (Native)](#windows-native)
- [Configuration Files](#configuration-files)
- [Key Mappings](#key-mappings)
- [Troubleshooting](#troubleshooting)
- [Customization](#customization)
- [Plugin Management](#plugin-management)

## Features

- **Dracula colorscheme** with custom cursor highlights
- **Telescope fuzzy finder** with file browser extension
- **nvim-tree file explorer** with Git integration
- **LSP support** for 15+ languages (Rust, C++, TypeScript, Python, etc.)
- **Auto-completion** with nvim-cmp and LuaSnip
- **Debug Adapter Protocol** (DAP) integration
- **Treesitter syntax highlighting** for 20+ languages
- **Session management** with persistence
- **Git integration** with LazyGit
- **CMake tools** for C++ development
- **Format on save** for all supported languages
- **Which-key** for discoverable key mappings
- **Terminal integration** with ToggleTerm

## Prerequisites

### Required Software

- **Neovim >= 0.9.0** (recommended: latest stable)
- **Git** (for plugin management)
- **Node.js >= 16** and **npm** (for LSP servers)
- **Python 3** and **pip** (for Python LSP and formatters)
- **Build tools** (gcc/clang, make)

### Optional Dependencies

- **Ripgrep** (for better telescope search)
- **fd** (for faster file finding)
- **LazyGit** (for git integration)
- **A Nerd Font** (for icons - recommended: Hack Nerd Font)

## Installation

### Linux/macOS

#### 1. Install Neovim

**Ubuntu/Debian:**

```bash
# Latest stable
sudo apt update
sudo apt install neovim

# Or latest via snap
sudo snap install nvim --classic

# Or build from source (latest features)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
export PATH="$PATH:/opt/nvim-linux64/bin"
```

**macOS:**

```bash
# Using Homebrew
brew install neovim

# Or using MacPorts
sudo port install neovim
```

**Arch Linux:**

```bash
sudo pacman -S neovim
```

#### 2. Install Dependencies

```bash
# Essential build tools
# Ubuntu/Debian:
sudo apt install -y build-essential git curl wget unzip ripgrep fd-find

# macOS:
brew install git curl wget unzip ripgrep fd

# Arch:
sudo pacman -S base-devel git curl wget unzip ripgrep fd

# Node.js and npm
# Ubuntu/Debian:
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# macOS:
brew install node

# Python dependencies
pip3 install --user black isort pyright

# Global npm packages for LSP
npm install -g typescript typescript-language-server prettier eslint
```

#### 3. Install Configuration

```bash
# Backup existing configuration
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null || true

# Create directory structure
mkdir -p ~/.config/nvim/lua/config
mkdir -p ~/.config/nvim/lua/plugins
mkdir -p ~/.config/nvim/snippets

# Clone this repository (or copy files manually)
git clone <repository-url> ~/.config/nvim

# OR create files manually - see "Configuration Files" section below
```

#### 4. First Run

```bash
# Start Neovim - plugins will auto-install
nvim

# Wait for lazy.nvim to install all plugins
# This may take a few minutes on first run
```

### Windows (WSL)

#### 1. Install WSL

```powershell
# In PowerShell as Administrator
wsl --install
# Restart your computer
```

#### 2. Set Up WSL Environment

```bash
# Update package manager
sudo apt update && sudo apt upgrade -y

# Install Neovim
sudo apt install -y neovim

# Install dependencies
sudo apt install -y build-essential git curl wget unzip ripgrep fd-find nodejs npm python3-pip

# Python packages
pip3 install --user black isort pyright

# Node.js packages
npm install -g typescript typescript-language-server prettier eslint

# Clipboard support (optional)
sudo apt install -y wl-clipboard
```

#### 3. Configure Windows Terminal

1. **Install Hack Nerd Font:**
   - Download from [nerdfonts.com](https://www.nerdfonts.com/font-downloads)
   - Install on Windows (double-click the .ttf files)

2. **Configure Windows Terminal:**
   - Open Windows Terminal Settings (Ctrl+,)
   - Go to Profiles → Ubuntu → Appearance
   - Set Font face to "Hack NF"
   - Set Font size to 11-12

#### 4. Install Neovim Configuration

Follow the same steps as Linux/macOS above, but make sure you're in your WSL home directory:

```bash
# Ensure you're in WSL home (not Windows filesystem)
cd ~
pwd  # Should show /home/username

# Then follow Linux installation steps
```

### Windows (Native)

#### 1. Install Neovim

- Download from [neovim.io](https://neovim.io)
- Or use Chocolatey: `choco install neovim`
- Or use Scoop: `scoop install neovim`

#### 2. Install Dependencies

```powershell
# Using Chocolatey
choco install git nodejs python ripgrep fd

# Or using Scoop
scoop install git nodejs python ripgrep fd
```

#### 3. Install Configuration

```powershell
# Configuration location on Windows
$env:LOCALAPPDATA\nvim

# Create directories
mkdir "$env:LOCALAPPDATA\nvim\lua\config"
mkdir "$env:LOCALAPPDATA\nvim\lua\plugins"
mkdir "$env:LOCALAPPDATA\nvim\snippets"

# Copy configuration files to this location
```

## Configuration Files

Create these files in your Neovim configuration directory:

### `init.lua`

```lua
-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
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
```

### File Structure

```
~/.config/nvim/
├── init.lua                    # Main entry point
├── lua/
│   ├── config/
│   │   ├── settings.lua        # Neovim settings
│   │   └── keymaps.lua         # Key mappings
│   └── plugins/
│       ├── colorscheme.lua     # Dracula theme
│       ├── completion.lua      # nvim-cmp setup
│       ├── debugging.lua       # DAP configuration
│       ├── file-explorer.lua   # nvim-tree
│       ├── lsp.lua            # LSP configuration
│       ├── telescope.lua       # Telescope fuzzy finder
│       ├── treesitter.lua     # Syntax highlighting
│       └── utilities.lua       # Other plugins
└── snippets/
    └── cpp.json               # Custom snippets
```

> **Note:** For the complete file contents, see the previous messages in this conversation or copy from the provided configuration files.

## ⌨️ Key Mappings

### Leader Key

- **Leader key:** `<Space>`

### File Operations

| Key          | Action           |
| ------------ | ---------------- |
| `<leader>ff` | Find files       |
| `<leader>fg` | Live grep        |
| `<leader>fb` | Show buffers     |
| `<leader>fh` | Help tags        |
| `<leader>e`  | File browser     |
| `<Ctrl-t>`   | Toggle nvim-tree |

### LSP Operations

| Key          | Action               |
| ------------ | -------------------- |
| `gd`         | Go to definition     |
| `gI`         | Go to implementation |
| `gr`         | Show references      |
| `K`          | Hover documentation  |
| `<leader>rn` | Rename symbol        |
| `<leader>ca` | Code actions         |
| `<leader>f`  | Format buffer        |

### Diagnostics

| Key         | Action                |
| ----------- | --------------------- |
| `[d`        | Previous diagnostic   |
| `]d`        | Next diagnostic       |
| `<leader>d` | Show diagnostic float |
| `<leader>q` | Diagnostic quickfix   |

### Session Management

| Key          | Action            |
| ------------ | ----------------- |
| `<leader>ss` | Save session      |
| `<leader>sr` | Restore session   |
| `<leader>sl` | Load last session |
| `<leader>sn` | Stop session      |

### Git Integration

| Key          | Action       |
| ------------ | ------------ |
| `<leader>gg` | Open LazyGit |

### Terminal

| Key          | Action                |
| ------------ | --------------------- |
| `<leader>tt` | Toggle terminal       |
| `<Ctrl-\>`   | Toggle terminal (alt) |

### Window Navigation

| Key        | Action                |
| ---------- | --------------------- |
| `<Ctrl-h>` | Move to left window   |
| `<Ctrl-j>` | Move to bottom window |
| `<Ctrl-k>` | Move to top window    |
| `<Ctrl-l>` | Move to right window  |

### Buffer Navigation

| Key          | Action          |
| ------------ | --------------- |
| `<Shift-l>`  | Next buffer     |
| `<Shift-h>`  | Previous buffer |
| `<leader>bd` | Close buffer    |

## 🔧 Troubleshooting

### Plugin Installation Issues

```vim
" In Neovim, run:
:Lazy sync
:Lazy clean
:Lazy update
```

### LSP Not Working

```vim
" Check LSP status:
:LspInfo

" Install/update language servers:
:Mason
```

### Treesitter Issues

```vim
" Update parsers:
:TSUpdate

" Install specific parser:
:TSInstall <language>
```

### Common Issues

#### 1. **Slow Performance**

- Ensure configuration is on local filesystem (not network drive)
- For WSL: Keep config in `/home/user/`, not `/mnt/c/`

#### 2. **Icons Not Showing**

- Install a Nerd Font (Hack Nerd Font recommended)
- Set terminal font to the Nerd Font
- Restart terminal

#### 3. **Clipboard Issues**

```bash
# Linux:
sudo apt install xclip  # or wl-clipboard for Wayland

# WSL:
curl -sLo win32yank.zip https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
unzip -p win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin/
```

#### 4. **Python LSP Issues**

```bash
# Ensure Python LSP is available:
pip3 install --user pyright black isort
```

#### 5. **Node.js LSP Issues**

```bash
# Update Node.js packages:
npm update -g typescript typescript-language-server
```

### WSL-Specific Issues

#### Performance Optimization

Add to `lua/config/settings.lua`:

```lua
-- WSL optimizations
vim.opt.shell = "/bin/bash"
vim.opt.updatetime = 300
```

#### File Permissions

```bash
# Fix ownership if needed:
sudo chown -R $USER:$USER ~/.config/nvim
sudo chown -R $USER:$USER ~/.local/share/nvim
```

## Customization

### Changing Colorscheme

Edit `lua/plugins/colorscheme.lua`:

```lua
return {
  {
    "folke/tokyonight.nvim",  -- Change this line
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight")  -- And this line
    end,
  },
}
```

### Adding New Plugins

Create a new file in `lua/plugins/` or add to existing files:

```lua
return {
  {
    "plugin-author/plugin-name",
    config = function()
      require("plugin-name").setup({
        -- configuration options
      })
    end,
  },
}
```

### Custom Keymaps

Add to `lua/config/keymaps.lua`:

```lua
keymap("n", "<leader>custom", "<cmd>YourCommand<CR>", opts)
```

### LSP Servers

Add to the `ensure_installed` table in `lua/plugins/lsp.lua`:

```lua
ensure_installed = {
  "rust_analyzer", "clangd", "your_new_lsp",
  -- ... existing servers
},
```

## Plugin Management

### Lazy.nvim Commands

```vim
:Lazy                 " Open plugin manager
:Lazy sync            " Install missing and update plugins
:Lazy clean           " Remove unused plugins
:Lazy update          " Update plugins
:Lazy profile         " Show startup time
```

### Mason Commands

```vim
:Mason                " Open LSP installer
:MasonUpdate          " Update Mason
:MasonInstall <server>" Install LSP server
:MasonUninstall <server>" Remove LSP server
```

## Additional Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Documentation](https://github.com/folke/lazy.nvim)
- [LSP Configuration Guide](https://github.com/neovim/nvim-lspconfig)
- [Treesitter Documentation](https://github.com/nvim-treesitter/nvim-treesitter)

## Contributing

Feel free to:

- Report issues
- Suggest improvements
- Submit pull requests
- Share your customizations

---
