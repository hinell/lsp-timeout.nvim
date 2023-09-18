## OVERVIEW
Nvim plugin for nvim-lspconfig: stop idle servers & restart upon focus; keep your RAM usage low


## INSTALL
Use your favorite package manager (Packer, Plug, Lazy.nvim etc.)

```
"hinell/lsp-timeout.nvim",
```

Prerequisites:
```
"neovim/nvim-lspconfig" 
```

E.g. for packer:
```lua
-- $HOME/.config/nvim/lua/user/init.lua
packer.setup(function(use)
    use({
	  "hinell/lsp-timeout.nvim",
	  requires={ "neovim/nvim-lspconfig" },
      setup = function()
        vim.g["lsp-timeout-config"] = {
            ...
        }
      end
    })
end)
```
<!-- ## API -->
## CONFIGURATION
```lua
vim.g["lsp-timeout-config"] = {
    -- When focus is lost
    -- wait 5 minutes before stopping all LSP servers
    stopTimeout=1000 * 60 * 5,
    startTimeout=1000 * 10 
}
```

<!-- ## EXAMPLES -->
<!-- ## KEYBINDINGS -->
<!-- ## LEGENDARY -->

----

September 16, 2023</br>
Copyright ©  - Alexander Davronov, et.al.<br>
