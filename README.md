<!---->

<div align="center">
  <h1 align="center">lsp-timeout.nvim<img width="32" src="https://neovim.io/logos/neovim-mark-flat.png" align="right" /></h1>
</div>

<!-- <img width="100%" src="doc/preview.png" /> -->
https://github.com/hinell/lsp-timeout.nvim/assets/8136158/92e30089-192f-4c75-8bec-85ca36a2c06c

<!-- Use badges from https://shields.io/badges/ -->
[![PayPal](https://img.shields.io/badge/-PayPal-880088?style=flat-square&logo=pay&logoColor=white&label=DONATE)](https://www.paypal.me/biteofpie)
[![License](https://img.shields.io/badge/FOSSIL-007744?style=flat-square&label=LICENSE)](https://github.com/hinell/fossil-license)

> _Nvim plugin for nvim-lspconfig: stop idle servers & restart upon focus; keep your RAM usage low_

## Overview

Some LSP servers are terribly inefficient at memory management and can
easily take up gigabytes of RAM if left unattended (just like VS Code huh?!). 
This plugin prevents excessive memory usage by stopping and restarting LSP servers 
automatically upon gaining or losing window focus, keeping neovim fast.


## ⚡Features

- Stop & start LSP servers upon demand
- Lower RAM usage by unsed Neovim system window

## 🔒Requirements
- [Neovim 0.7.2+](https://github.com/neovim/neovim/releases)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

## 📦 Installation

#### [lazy.vim](https://github.com/folke/lazy.nvim)
```lua
require("lazy").setup(
    {
        "hinell/lsp-timeout.nvim",
        dependencies={ "neovim/nvim-lspconfig" }
    }
)
```

#### [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
-- $HOME/.config/nvim/lua/user/init.lua
packer.setup(function(use)
    use({
        "hinell/lsp-timeout.nvim",
        requires={ "neovim/nvim-lspconfig" }
    })
end)
```

#### [vim-plug](https://github.com/junegunn/vim-plug)
``` vim
Plug "hinell/lsp-timeout.nvim"
```

<!-- ## 🚀 Usage -->
 

### [DOCUMENTATION]
### [CONTRIBUTING]
### [DEVELOPMENT]

[DOCUMENTATION]: doc/lsp-timeout.md 'Contribution instructions (see also source code files)'
[CONTRIBUTING]: CONTRIBUTING.md 'Contribution instructions (see also source code files)'
[DEVELOPMENT]: DEVELOPMENT.md 'Devloper documentation (see also source code files)'

### [SUPPORT DISCLAIMER][SD]
[SD]: #production-status--support 'Production use disclaimer & support info'

_NO GUARANTEES UNTIL PAID. This project is supported and provided AS IS. See also [LICENSE]._

[LICENSE]: LICENSE

### SEE ALSO
* [@hinell/lsp-timeout.nvim](https://github.com/hinell/lsp-timeout.nvim) -  halt LSP servers when you leave nvim window 
* [@hinell/duplicate.nvim](https://github.com/hinell/duplicate.nvim) - duplicate selection
* [@hinell/nvim-tree-git.nvim](https://github.com/hinell/nvim-tree-git.nvim) - GIT integration plugin for infamous file explorer 
----

September 26, 2023</br>
Copyright ©  - Alexander Davronov (a.k.a Hinell), et.al.</br>
