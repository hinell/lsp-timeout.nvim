## OVERVIEW
Nvim plugin for nvim-lspconfig: stop idle servers & restart upon gaining or loosing focus;
keep your RAM usage low;


## INSTALL
Use your favorite package manager (Packer, Plug, Lazy.nvim etc.)

```
"hinell/lsp-timeout.nvim"
```

Prerequisites:

* Neovim v0.7.2+
* `"neovim/nvim-lspconfig"`

E.g. for packer:
```lua
-- $HOME/.config/nvim/lua/user/init.lua
-- Don't forget to run :PackerCompile
packer.setup(function(use)
    use({
      "hinell/lsp-timeout.nvim",
      requires={ "neovim/nvim-lspconfig" },
      setup = function()
        vim.g["lsp-timeout-config"] = {
            -- 
        }
      end
    })
end)
```

Lazy.nvim:

```lua
{
    "hinell/lsp-timeout.nvim",
    dependencies={ "neovim/nvim-lspconfig" },
    init = function()
        vim.g["lsp-timeout-config"] = {
        -- 
        }
    end
}
```

## UPDATE

You may want to reinstall this plugin manually because of specific dev-approach:
repo of this plugin may be force-pushed & force-rebased,
rendering all previous commits obsolete; read DEVELOPMENT.md for more info

<!-- ## API -->
## CONFIGURATION
```lua
vim.g["lsp-timeout-config"] = {
    stopTimeout  = 1000 * 60 * 5,  -- ms, timeout before stopping all LSP servers
    startTimeout = 1000 * 10,      -- ms, timeout before restart
    silent       = false           -- true to suppress notifications
}
```

### TROUBLESHOOTING

> **Note** IF SOME PLUGIN FAILED BECAUSE OF STOPPED LSP, PLEASE, FILL AN ISSUE IN THE RESPECTIVE PLUGIN REPO

* Some LSP servers which don't keep cache on hdd may fail.
* Some plugins that require active LSP servers like those used for signs may also fail:
if they don't hook into |LspAttach| or |LspDetach| events or if they don't use `vim.lsp.get_clients(...)`. 

#### null-ls

Please, see https://github.com/hinell/lsp-timeout.nvim/issues/7#issuecomment-1764402683


<!-- ## EXAMPLES -->
<!-- ## KEYBINDINGS -->
<!-- ## LEGENDARY -->

----

September 26, 2023</br>
Copyright ©  - Alexander Davronov, et.al.<br>
