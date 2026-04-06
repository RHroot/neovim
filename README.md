# 🌙 Neovim Configuration - RHroot's Power Setup

> A blazing-fast, feature-rich Neovim configuration crafted for developers who demand performance, elegance, and productivity.

![Lua](https://img.shields.io/badge/Lua-000080?style=flat-square&logo=lua&logoColor=white)
![Neovim](https://img.shields.io/badge/Neovim-57A143?style=flat-square&logo=neovim&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

---

## ✨ Highlights

🚀 **Ultra-Modern Stack** — Built on Neovim's latest features with vim.pack for dependency management

🎨 **Beautiful Theme** — Tokyo Night color scheme with custom black background for reduced eye strain

🧠 **AI-Powered** — GitHub Copilot integration + Copilot Chat for intelligent code suggestions

⚙️ **Smart Completion** — Blink.cmp with LSP, snippets, and smart keybindings

🔧 **Multi-Language Support** — 40+ languages with LSP, TreeSitter, and dedicated formatters

📝 **Intelligent Editing** — Mini.nvim ecosystem for surround operations, autopairs, and more

🎯 **Fuzzy Finding** — Mini.pick for blazing-fast file/buffer/grep searches

📊 **Developer Experience** — Git integration, diagnostics, minimap, and beautiful statusline

🏃 **Built-in Runners** — Execute code directly from the editor (Python, Rust, Go, JS, and more)

---

## 📦 Core Dependencies

### Package Manager

- **vim.pack** — Built-in Neovim plugin management (no external package managers needed)

### Essential Plugins

#### 🎨 **UI & Theming**

- **tokyonight.nvim** — Tokyo Night color scheme with custom tweaks
- **mini.nvim** — Lightweight mega-pack including:
  - `mini.statusline` — Custom status bar with LSP, git, and file info
  - `mini.tabline` — Beautiful tab line
  - `mini.clue` — Which-key style hints for keybindings
  - `mini.pick` — Fuzzy finder (files, buffers, grep)
  - `mini.map` — Visual code minimap
  - `mini.indentscope` — Visual indent guides
  - `mini.files` — File explorer
  - `mini.ai` — Text object enhancements
  - `mini.surround` — Surround operations (similar to vim-surround)
  - `mini.pairs` — Auto-pairing brackets and quotes
  - `mini.icons` — Nerd font icons
  - `mini.diff` — Git diff visualization
  - `mini.git` — Git operations
  - `mini.notify` — Beautiful notifications
  - `mini.sessions` — Session management
  - `mini.trailspace` — Trim trailing whitespace
  - `mini.operators` — Custom operators
  - `mini.animate` — Smooth animations
  - `mini.cursorword` — Highlight cursor word
  - `mini.hipatterns` — Highlight hex colors and patterns
  - `mini.extra` — Extra utilities
  - And more...

#### 🧠 **Language & Completion**

- **nvim-lspconfig** — LSP configuration for multiple languages
- **mason.nvim** — Language server and tool installer
- **mason-tool-installer.nvim** — Auto-install tools on startup
- **blink.cmp** — Modern completion engine with LSP integration
- **nvim-treesitter** — Advanced syntax highlighting and code parsing (40+ languages)

#### 🔧 **Code Quality**

- **conform.nvim** — Code formatter with support for:
  - Lua (stylua)
  - Python (ruff)
  - JavaScript/TypeScript (prettierd)
  - Go (gofumpt, goimports)
  - Rust (rustfmt)
  - SQL (sqruff)
  - And 15+ more languages

#### 🤖 **AI Integration**

- **copilot.vim** — GitHub Copilot for inline suggestions
- **CopilotChat.nvim** — Interactive AI chat interface (Claude Haiku 4.5)

#### 🛠️ **Utilities**

- **plenary.nvim** — Lua library for common tasks

---

## 🎮 Keybindings Cheat Sheet

### 🎯 General

| Binding      | Action                           |
| ------------ | -------------------------------- |
| `<Space>`    | Leader key                       |
| `;`          | Remap `:` (faster command entry) |
| `<C-c>`      | Escape everywhere                |
| `<leader>ww` | Save file                        |
| `<leader>qq` | Quit                             |
| `<leader>ex` | Force quit                       |
| `<leader>rt` | Restart Neovim                   |
| `<leader>si` | Source init.lua                  |

### 📂 File Navigation

| Binding           | Action                       |
| ----------------- | ---------------------------- |
| `<leader><space>` | Find files (hidden, no .git) |
| `<leader>/`       | Live grep                    |
| `<leader>bf`      | Browse buffers               |
| `<leader>e`       | Explorer (current file dir)  |
| `<leader>E`       | Explorer (working directory) |
| `<leader>rl`      | Resume last picker           |
| `<leader>hp`      | Help tags                    |

### 🔍 LSP & Navigation

| Binding       | Action                   |
| ------------- | ------------------------ |
| `<leader>gd`  | Go to definition         |
| `<leader>gr`  | Find references          |
| `<leader>gi`  | Go to implementation     |
| `K`           | Hover documentation      |
| `<C-s>`       | Signature help           |
| `<leader>ca`  | Code action              |
| `<leader>sn`  | Rename symbol            |
| `<leader>sw`  | Search workspace symbols |
| `<leader>aw`  | Add workspace folder     |
| `<leader>for` | Format buffer            |

### ✏️ Editing

| Binding                  | Action                         |
| ------------------------ | ------------------------------ |
| `<leader>fm`             | Format buffer                  |
| `<leader>f`              | Format selection (visual mode) |
| `<leader>tw`             | Trim trailing whitespace       |
| `<leader>url`            | Open URL under cursor          |
| `<C-_>` (or `<leader>_`) | Toggle comment                 |
| `K` / `J` (visual)       | Move selection up/down         |
| `<C-d>` / `<C-u>`        | Scroll centered                |

### 🧠 Copilot

| Binding      | Action              |
| ------------ | ------------------- |
| `<A-p>`      | Accept suggestion   |
| `<A-]>`      | Next suggestion     |
| `<A-[>`      | Previous suggestion |
| `<A-x>`      | Dismiss suggestion  |
| `<leader>cc` | Toggle Copilot Chat |

### 💾 Git Integration

| Binding      | Action                 |
| ------------ | ---------------------- |
| `<leader>gs` | Git status             |
| `<leader>gc` | Git commit             |
| `<leader>gL` | Git log                |
| `<leader>gh` | Git range history      |
| `]h` / `[h`  | Next/previous git hunk |
| `]H` / `[H`  | Last/first git hunk    |
| `<leader>go` | Toggle diff overlay    |

### 🎵 Windows & Splits

| Binding       | Action           |
| ------------- | ---------------- |
| `<C-h/j/k/l>` | Navigate splits  |
| `<leader>sv`  | Vertical split   |
| `<leader>sh`  | Horizontal split |
| `<leader>qn`  | Next buffer      |
| `<leader>qp`  | Previous buffer  |
| `<leader>qd`  | Delete buffer    |

### 💾 Sessions & Misc

| Binding      | Action                |
| ------------ | --------------------- |
| `<leader>ss` | Select session        |
| `<leader>ws` | Write/save session    |
| `<leader>mm` | Toggle minimap        |
| `<leader>nd` | Dismiss notifications |
| `<leader>nh` | Notification history  |
| `<leader>rn` | Run current file      |

---

## 🚀 Quick Start

### Installation

```bash
# Clone or use this as your nvim config
git clone https://github.com/RHroot/neovim.git ~/.config/nvim
cd ~/.config/nvim
```

### First Launch

1. Open Neovim: `nvim`
2. The config will auto-install plugins via vim.pack
3. Mason will auto-install language servers on first LSP attach
4. You're ready to code! 🎉

### Plugin Management

Edit `init.lua` and add plugins in the `vim.pack.add()` section:

```lua
vim.pack.add({
  { src = "https://github.com/username/plugin.nvim" },
})
```

---

## 🌍 Supported Languages

### 🏗️ **Infrastructure & Systems**

Go • Rust • C • C++ • Zig • Java

### 🌐 **Web & Frontend**

JavaScript • TypeScript • HTML • CSS • Vue • Svelte • Astro

### 🐍 **Scripting**

Python • Lua • Bash • Ruby • PHP • Perl • Nix

### 📊 **Data & Databases**

SQL • JSON • YAML • TOML • CSV • PostgreSQL

### 📝 **Markup & Docs**

Markdown • LaTeX • Dockerfile • Git Commits

---

## ⚙️ Customization

### Theme Customization

Tokyo Night theme is customized with:

- Pure black background (#000000) for reduced eye strain
- Custom orange (#F09676) accents
- Transparent floats and sidebars
- Custom cursor line highlighting

Edit the theme setup in `init.lua`:

```lua
tokyonight.setup({
  style = "night",
  -- Your custom settings here
})
```

### Keybindings

Modify keybindings in the **Keymaps** section:

```lua
map("n", "<leader>xyz", ":YourCommand<CR>", { desc = "Your description" })
```

### LSP Servers

Add/remove servers in the `servers` table:

```lua
local servers = {
  "zls", "gopls", "pylsp", -- Add your servers here
}
```

### Formatters

Configure formatters in `conform.nvim` setup:

```lua
formatters_by_ft = {
  lua = { "stylua" },
  python = { "ruff_format" },
  -- Add your formatters
}
```

---

## 🎨 File Runners

Execute code directly from Neovim with `<leader>rn`:

| Language   | Command                        |
| ---------- | ------------------------------ |
| Python     | `python %`                     |
| Lua        | `lua %`                        |
| Bash       | `bash %`                       |
| JavaScript | `node %`                       |
| TypeScript | `ts-node %`                    |
| Go         | `go run %`                     |
| Rust       | `rustc % && ./target/...`      |
| C          | `gcc % -o %< && ./%<`          |
| C++        | `g++ % -std=c++17 -O2 && ./%<` |
| Java       | `javac % && java %<`           |
| Ruby       | `ruby %`                       |
| PHP        | `php %`                        |
| Perl       | `perl %`                       |
| Zig        | `zig run %`                    |

---

## 🔧 Advanced Features

### Mini.nvim Ecosystem

This config leverages Mini.nvim for a lightweight yet powerful experience:

- **No bloat** — Pure Lua, minimal dependencies
- **Fast startup** — Sub-100ms loading time
- **Modular** — Use only what you need
- **Extensible** — Easy to customize each component

### Diagnostics & Errors

- Virtual line diagnostics (hover for details)
- Floating error boxes with intelligent positioning
- Custom diagnostic signs with icons
- LSP-driven insights

### Git Integration

- Full git status and log viewing
- Hunk navigation with ]h/[h
- Diff overlay for visual comparison
- Range history for code sections

### Color Highlighting

Mini.hipatterns automatically highlights:

- Hex colors (#fff, #ffffff)
- RGB colors (rgb(255, 0, 0))
- HSL colors (hsl(0, 100%, 50%))

### Smart Completion

Blink.cmp provides:

- LSP-driven completions
- Snippet expansion with Tab/Shift-Tab
- Ghost text preview
- Documentation on hover
- Intelligent sorting

---

## 📊 Status Line Features

The custom status line displays:

- 🎯 **Mode** — Current vim mode with color coding
- 🌳 **Git Info** — Branch and status
- 📝 **Filename** — Current file with truncation
- 🚨 **Diagnostics** — Error/warning counts
- 💾 **File Size** — Human-readable file size
- 📍 **Position** — Line and column number
- 🤖 **LSP Status** — Active language servers

---

## 🎯 Performance Optimizations

- **Lazy LSP** — Language servers load on demand
- **Async Formatting** — Non-blocking code formatting
- **Efficient Search** — Ripgrep integration for fast grepping
- **Minimal Config** — No unnecessary bloat or startup slowness

---

## 🐛 Troubleshooting

### Plugins not loading?

Check the lock file: `nvim-pack-lock.json`

```bash
# Regenerate lock file
rm nvim-pack-lock.json
nvim  # Will regenerate
```

### LSP not working?

- Check `:LspInfo` for server status
- Ensure Mason installed the server: `:Mason`
- Verify language is in the `servers` table

### Copilot issues?

- Ensure GitHub CLI is authenticated: `gh auth login`
- Restart Neovim after auth changes

### Slow startup?

- Check startup time: `nvim --startuptime startup.log`
- Profile with: `:Profiling` (if available)

---

## 🚀 Advanced Tips

1. **Quick Session Save** — `:write` + `<leader>ws` to save layout
2. **Range Formatting** — Visual select + `<leader>f` to format
3. **Workspace Symbols** — `<leader>sw` to search across project
4. **Code Actions** — `<leader>ca` to access LSP quick fixes
5. **Git History** — `<leader>gh` to see changes by line

---

## 📝 File Structure

```
~/.config/nvim/
├── init.lua              # Main configuration (1272 lines of power!)
├── nvim-pack-lock.json   # Plugin lock file
├── .luarc.json          # Lua LSP configuration
└── README.md            # This file
```

---

## 🤝 Contributing

Feel free to fork, modify, and enhance this configuration for your workflow!

### Credits

- **Base**: Modern Neovim best practices
- **Theme**: Tokyo Night by folke
- **Components**: Mini.nvim ecosystem
- **Author**: RHroot

---

## 📄 License

MIT License — Use freely in your projects!

---

## 🎉 Final Notes

This configuration is designed for **serious developers** who want:

- ⚡ Lightning-fast navigation
- 🧠 Intelligent code completion
- 🎨 Beautiful aesthetics
- 🔧 Maximum customizability
- 🚀 Performance without compromise

**Happy coding!** 🚀✨

---

[GitHub](https://github.com/RHroot/neovim) • [Codeberg](https://codeberg.org/RHroot/neovim)

</div>
