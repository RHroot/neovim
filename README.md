<div align="center">

# 🌙 neovim

**A fast, minimal, and beautiful Neovim configuration**

Built with [lazy.nvim](https://github.com/folke/lazy.nvim) · Lua-first · 14 LSP servers · 16+ formatters · AI-powered

![Neovim](https://img.shields.io/badge/Neovim-0.10%2B-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

</div>

---

## ✨ Features

- 🎨 **Tokyo Night** colorscheme with transparent backgrounds
- 🧠 **14 LSP servers** — Go, Python, Rust, TypeScript, C/C++, Java, Lua, Zig, HTML/CSS, SQL, and more
- 🤖 **GitHub Copilot + CopilotChat** for AI-assisted coding
- 📐 **Conform.nvim** formatting for 16+ languages
- 🔍 **Snacks.nvim** — fuzzy finder, file explorer, lazygit, zen mode, dashboard, and more
- 🌳 **Treesitter** syntax highlighting with auto-install
- 📊 **Mini.nvim** — statusline, indent highlights, text objects, hex color previews
- 🔔 **Noice.nvim** — modern command UI and notifications
- ⚡ **Blink.cmp** — fast, PyCharm-style completion with snippet support
- 🔒 **Cloak.nvim** — hide secrets in `.env` files
- 🖼️ **Image preview** support (PNG, JPG, GIF, WebP, and more)
- ✂️ **LuaSnip + friendly-snippets** with custom snippets support
- 🔔 **nvim-notify** for LSP events and rich alerts

---

## 📁 Structure

```
~/.config/nvim/
├── init.lua              # Entry point — loads core modules and plugins
├── lazy-lock.json        # Lazy.nvim lockfile
├── lua/
│   ├── core/
│   │   ├── auto.lua      # Autocommands, LSP keybinds, diagnostics, custom commands
│   │   ├── maps.lua      # Key mappings (leader = Space)
│   │   └── opts.lua      # Editor options (tabs, search, UI, font)
│   └── plugins/
│       ├── autopairs.lua # Auto bracket/quote pairing
│       ├── cloak.lua     # Environment variable masking
│       ├── cmd.lua       # Noice command UI config
│       ├── colors.lua    # Tokyo Night colorscheme
│       ├── copilot.lua   # GitHub Copilot + CopilotChat
│       ├── formatter.lua # Conform formatter config (16+ languages)
│       ├── git.lua       # Gitsigns config
│       ├── lsp-cmp.lua   # LSP servers + Blink.cmp completion
│       ├── mini.lua      # Mini statusline, hi-patterns, ai, icons
│       ├── notify.lua    # Notification system
│       ├── snacks.lua    # Fuzzy finder, explorer, lazygit, zen, dashboard
│       ├── treesitter.lua# Syntax highlighting
│       └── whichkey.lua  # Keymap discovery popup
└── snippets/
    ├── package.json      # Snippet manifest
    └── go.json           # Custom Go snippets
```

---

## 🚀 Installation

### Prerequisites

- [Neovim](https://neovim.io/) **v0.10+**
- [Git](https://git-scm.com/)
- A [Nerd Font](https://www.nerdfonts.com/) (JetBrainsMono NF recommended)
- A terminal with true color support ([Kitty](https://sw.kovidgoyal.net/kitty/), [WezTerm](https://wezfurlong.org/wezterm/), etc.)

### Steps

**1. Back up your existing config (if any)**

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

**2. Clone this repository**

```bash
git clone https://github.com/RHroot/neovim.git ~/.config/nvim
```

**3. Open Neovim and install plugins**

```bash
nvim
```

On first launch, run:

```vim
:Lazy
```

**4. Install LSP servers, formatters, and tools**

You'll need the following tools available on your `$PATH`. Install them with your system package manager or language-specific tools:

<details>
<summary><b>LSP Servers</b></summary>

| Language   | Server            | Install                                                                               |
| ---------- | ----------------- | ------------------------------------------------------------------------------------- |
| Go         | `gopls`           | `go install golang.org/x/tools/gopls@latest`                                          |
| Python     | `pylsp`           | `pip install python-lsp-server`                                                       |
| Rust       | `rust-analyzer`   | `rustup component add rust-analyzer`                                                  |
| TypeScript | `ts_ls` / `vtsls` | `npm i -g typescript typescript-language-server @vtsls/language-server`               |
| Lua        | `lua_ls`          | [lua-language-server releases](https://github.com/LuaLS/lua-language-server/releases) |
| C/C++      | `clangd`          | `apt install clangd` or via LLVM                                                      |
| Java       | `jdtls`           | [eclipse.jdt.ls](https://github.com/eclipse-jdtls/eclipse.jdt.ls)                     |
| HTML       | `html`            | `npm i -g vscode-langservers-extracted`                                               |
| CSS        | `cssls`           | `npm i -g vscode-langservers-extracted`                                               |
| Tailwind   | `tailwindcss`     | `npm i -g @tailwindcss/language-server`                                               |
| SQL        | `postgres_lsp`    | [postgres_lsp](https://github.com/supabase-community/postgres-language-server)        |
| Zig        | `zls`             | [zls releases](https://github.com/zigtools/zls/releases)                              |

</details>

<details>
<summary><b>Formatters</b></summary>

| Language               | Formatter              | Install                                                                                    |
| ---------------------- | ---------------------- | ------------------------------------------------------------------------------------------ |
| Lua                    | `stylua`               | `cargo install stylua`                                                                     |
| Python                 | `ruff`                 | `pip install ruff`                                                                         |
| JS/TS/HTML/CSS/JSON/MD | `prettierd`            | `npm i -g @fsouza/prettierd`                                                               |
| Go                     | `gofumpt`, `goimports` | `go install mvdan.cc/gofumpt@latest && go install golang.org/x/tools/cmd/goimports@latest` |
| Rust                   | `rustfmt`              | `rustup component add rustfmt`                                                             |
| C/C++                  | `clang-format`         | `apt install clang-format`                                                                 |
| Shell                  | `shfmt`                | `go install mvdan.cc/sh/v3/cmd/shfmt@latest`                                               |
| Java                   | `google-java-format`   | [google-java-format releases](https://github.com/google/google-java-format/releases)       |
| SQL                    | `sqruff`               | `pip install sqruff`                                                                       |
| Fish                   | `fish_indent`          | Comes with [fish shell](https://fishshell.com/)                                            |
| Nix                    | `alejandra`            | `nix-env -iA nixpkgs.alejandra`                                                            |
| Zig                    | `zigfmt`               | Comes with [Zig](https://ziglang.org/)                                                     |

</details>

**5. Install Treesitter parsers**

```vim
:TSUpdate
```

---

## ⌨️ Keybindings

> **Leader** = `Space` · **Local Leader** = `\`

### General

| Key          | Mode   | Action                     |
| ------------ | ------ | -------------------------- |
| `<C-c>`      | All    | Escape                     |
| `;`          | Normal | Enter command mode         |
| `<leader>w`  | Normal | Save file                  |
| `<leader>q`  | Normal | Quit                       |
| `<leader>ex` | Normal | Force quit                 |
| `<leader>so` | Normal | Save & source current file |
| `<leader>si` | Normal | Source `init.lua`          |
| `<Esc>`      | Normal | Clear search highlights    |

### Navigation

| Key               | Mode   | Action                             |
| ----------------- | ------ | ---------------------------------- |
| `<C-h/j/k/l>`     | Normal | Navigate between splits            |
| `<C-d>` / `<C-u>` | Normal | Scroll down/up (centered)          |
| `n` / `N`         | Normal | Next/prev search result (centered) |
| `[[` / `]]`       | Normal | Previous/next word reference       |

### File Explorer & Buffers

| Key                         | Mode   | Action                   |
| --------------------------- | ------ | ------------------------ |
| `<leader>e`                 | Normal | Toggle file explorer      |
| `<leader>cd`                | Normal | Open netrw (current dir)  |
| `<leader>,`                 | Normal | Open buffer list          |
| `<leader>bn` / `<leader>bp` | Normal | Next/previous buffer      |
| `<leader>bd`                | Normal | Delete buffer             |
| `<leader>bc`                | Normal | New buffer                |
| `<leader>.`                 | Normal | Open scratch buffer       |
| `<leader>S`                 | Normal | Select scratch buffer     |

### Fuzzy Finder (Snacks Picker)

| Key               | Mode   | Action            |
| ----------------- | ------ | ----------------- |
| `<leader><space>` | Normal | Smart find        |
| `<leader>ff`      | Normal | Find files        |
| `<leader>/`       | Normal | Live grep         |
| `<leader>sw`      | Normal | Grep current word |
| `<leader>fr`      | Normal | Recent files      |
| `<leader>:`       | Normal | Command history   |
| `<leader>sh`      | Normal | Help tags         |
| `<leader>sk`      | Normal | Keymaps           |
| `<leader>fp`      | Normal | Projects          |

### LSP

| Key          | Mode          | Action                  |
| ------------ | ------------- | ----------------------- |
| `gd`         | Normal        | Go to definition        |
| `gr`         | Normal        | Find references         |
| `gi`         | Normal        | Go to implementation    |
| `K`          | Normal        | Hover documentation     |
| `<C-k>`      | Normal        | Signature help          |
| `<leader>ca` | Normal        | Code action             |
| `<leader>rn` | Normal        | Rename symbol           |
| `<leader>fe` | Normal        | Diagnostics float       |
| `<leader>fm` | Normal/Visual | Format buffer/selection |
| `<leader>for`| Normal        | Format buffer (async)   |

### Git

| Key          | Mode   | Action                       |
| ------------ | ------ | ---------------------------- |
| `<leader>gg` | Normal | LazyGit                      |
| `<leader>gb` | Normal | Git branches                 |
| `<leader>gl` | Normal | Git log                      |
| `<leader>gs` | Normal | Git status                   |
| `<leader>gd` | Normal | Git diff                     |
| `<leader>gB` | Normal | Git browse (open in browser) |
| `<leader>gS` | Normal | Git stash                    |
| `<leader>gf` | Normal | Git file history             |

### AI (Copilot)

| Key          | Mode   | Action                    |
| ------------ | ------ | ------------------------- |
| `<A-p>`      | Insert | Accept Copilot suggestion |
| `<leader>cc` | Normal | Toggle CopilotChat        |

### Toggles

| Key          | Mode   | Action             |
| ------------ | ------ | ------------------ |
| `<leader>us` | Normal | Toggle spell check   |
| `<leader>uw` | Normal | Toggle word wrap     |
| `<leader>ud` | Normal | Toggle diagnostics   |
| `<leader>uh` | Normal | Toggle inlay hints   |
| `<leader>uz` | Normal | Toggle zen mode      |
| `<leader>uZ` | Normal | Toggle zoom          |
| `<leader>uC` | Normal | Pick colorscheme     |
| `<leader>ub` | Normal | Toggle dark mode     |
| `<leader>uT` | Normal | Toggle Treesitter    |
| `<leader>uD` | Normal | Toggle dim mode      |
| `<leader>uL` | Normal | Toggle relative line |
| `<leader>ul` | Normal | Toggle line numbers  |
| `<leader>uN` | Normal | Toggle line number   |
| `<leader>uc` | Normal | Toggle conceal       |
| `<leader>ug` | Normal | Toggle indent guides |

### Editing

| Key         | Mode          | Action                          |
| ----------- | ------------- | ------------------------------- |
| `J` / `K`   | Visual        | Move selected lines down/up     |
| `<leader>y` | Normal/Visual | Copy to system clipboard        |
| `<leader>d` | Normal/Visual | Delete to void register         |
| `<leader>p` | Visual        | Paste without yanking selection |
| `<C-_>`     | Normal/Visual | Toggle comment                  |
| `<C-n>`     | Insert/Select | Snippet jump forward            |
| `<C-p>`     | Insert/Select | Snippet jump backward           |
| `<C-e>`     | Insert/Select | Cycle snippet choice            |

---

## 🎨 Screenshots

> Add your own screenshots here!
>
> Suggested: dashboard, editor with LSP, fuzzy finder, lazygit, zen mode

---

## 🛠️ Custom Commands

| Command        | Description                |
| -------------- | -------------------------- |
| `:ConformInfo` | Show Conform formatter info |

---

## 🔧 Customization

- **Add plugins** — Create a plugin spec in `lua/plugins/` and add it to the lazy loader
- **Change colorscheme** — Edit `lua/plugins/colors.lua` or press `<leader>uC` to pick one live
- **Add keybindings** — Edit `lua/core/maps.lua`
- **Add formatters** — Edit `lua/plugins/formatter.lua` (Conform format)
- **Add LSP servers** — Edit `lua/plugins/lsp-cmp.lua` and add the server name to `vim.lsp.enable`
- **Add snippets** — Create a JSON file in `snippets/` and register it in `snippets/package.json`

---

## 📝 Notes

- **First launch** will show warnings about missing plugins — open `:Lazy` and sync
- **lazy.nvim** is bootstrapped automatically in `init.lua` — no separate installation needed
- The config auto-reloads Kitty terminal config on save
- Swap files are disabled; persistent undo is stored in `~/.vim/undodir`
- Neovide is supported with custom font and opacity settings

---

<div align="center">

**Made with ❤️ and Lua**

</div>
