## OVERVIEW

Nvim plugin for nvim-lspconfig: stop idle servers & restart upon gaining focus;
keeps RAM usage low

**Default behavior**:
* Tabpages and windows inside - are traversed & checked for LSPs
* The |'diff'| windows and |'readonly'| buffers are ignored - `lsp-timeout` takes no action
* On focused writable windows (cursor put on) `lsp-timeout` finds and restarts available LSPs 

## INSTALL
Use your favorite package manager (Packer, Plug, Lazy.nvim etc.); it's advised to use`latest` tag

```
"hinell/lsp-timeout.nvim"
```

Prerequisites:

* Neovim v0.7.2+
* nvim-lspconfig: https://github.com/neovim/nvim-lspconfig


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

> **WARNING**
> Packer.nvim is archived

Packer:
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

## UPDATE

Repo of this plugin may be force-pushed & force-rebased,
rendering all previous commits obsolete so manual updates are advised;
See DEVELOPMENT.md for more info.

<!-- ## API -->
## CONFIGURATION
```lua
vim.g["lsp-timeout-config"] = {
    stopTimeout  = 1000 * 60 * 5, -- ms, timeout before stopping all LSPs 
    startTimeout = 1000 * 10,     -- ms, timeout before restart
    silent       = false          -- true to suppress notifications
}
```

```lua
-- Optionally, validate config
local Config = require("lsp-timeout.config").Config
      Config:new(vim.g["lsp-timeout-config"]):validate()
```

### Augroups

Plugin setups two augroups:
* `LSPTimeout` - global augroup for various events 
* `LSPTimeoutBufferLocal` - buffer-local groups, temporary 

### TROUBLESHOOTING

> **Note**
> IF SOME PLUGIN FAILED BECAUSE OF STOPPED LSP, PLEASE, FILL AN ISSUE IN A RESPECTIVE PLUGIN REPO

* Run `LspInfo` to find (in)active LSPs
* Use `map <...>` to check what keymaps are setup/lost upon restart 
* If you hook into |LspAttach| and |LspDetach| events, make sure to store & clean up buffer-local variables or keymaps only once per every cycle

#### TROUBLESHOOTING PLUGINS
* Some plugins that require active LSP servers like ones used for signs may fail if they don't hook into |LspAttach| or |LspDetach| events or `vim.lsp.get_clients(...)` properly 
* Some LSP servers may misbehave upon restart if they don't keep cache
* Some LSP plugins may hook into serveral LSPs and fail upon restart  
* See also: https://github.com/neovim/nvim-lspconfig#troubleshooting

Plugins that are known to misbehave:
* **null-ls**: fails to startup, replace by `efm-languageserver` or use workaround,
<br/>see https://github.com/hinell/lsp-timeout.nvim/issues/7#issuecomment-1764402683

* **efm-languageserver**: 
<br/>make sure that `filetypes` are specified in the setup config
<br/>see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#efm

* **barbecue.nvim**: 
<br/>**nvim-navic**:
<br/>you have to attach `navic.nvim` to one specific LSP; avoid attaching it to generic (e.g. efmls) LSPs:
<br/>see: https://github.com/utilyre/barbecue.nvim 
```lua
require("lspconfig")[serverName].setup({
  on_attach = function(client, bufnr)
    -- ...
    if client.server_capabilities["documentSymbolProvider"] then
      require("nvim-navic").attach(client, bufnr)
    end
  end,
```

<!-- ## EXAMPLES -->
<!-- ## KEYBINDINGS -->
<!-- ## LEGENDARY -->

----

September 26, 2023</br>
Copyright ©  - Alexander Davronov, et.al.<br>
