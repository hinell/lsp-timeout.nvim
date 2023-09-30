vim.api.nvim_create_augroup("LspTimeout", {clear = true})
vim.api.nvim_create_autocmd({"BufEnter"}, {
	desc = "Check if nvim-lspconfig commands are available",
	group = "LspTimeout",
	once = true,
	callback = function()
		--- Return true if no lsp-config commands are found
		if vim.fn.exists(":LspStart") == 0 or vim.fn.exists(":LspStop") == 0 then
			local message =
				"no LspStart command is found. Make sure lsp-config.nvim is installed"
			error(("%s: %s"):format(debug.getinfo(1).source, message))
			return true
		end
	end
})
vim.api.nvim_create_autocmd({"FocusGained"}, {
	desc = "Rerstart LSP server if window is focused",
	group = "LspTimeout",
	callback = function(options)
		-- Clear lsp stop timer
		if _G.nvimLspTimeOutStopTimer then
			_G.nvimLspTimeOutStopTimer:stop()
			_G.nvimLspTimeOutStopTimer:close()
			_G.nvimLspTimeOutStopTimer = nil
		end

		if not _G.nvimLspTimeOutStartTimer then
			-- Checks if it's nightly or not
			local configDefault = require("lsp-timeout.config").default
			local config = configDefault:extend(vim.g["lsp-timeout-config"] or {})
			config:validate()
			-- Postpone startup
			local timeout = config.startTimeout

			-- ref: https://github.com/neovim/neovim/pull/22846
			local uv = vim.uv or vim.loop
			_G.nvimLspTimeOutStartTimer = uv.new_timer()
			_G.nvimLspTimeOutStartTimer:start(timeout, 0, vim.schedule_wrap(function()
				local clientsNum = #(require("lsp-timeout.nvim-api").lsp:clients({ buf = options.buf }))
				if clientsNum < 1 then
					if not config.silent then
						-- LuaFormatter off
						vim
						.notify( ("lsp-timeout: %s servers found, restarting... ")
						:format( clientsNum), vim.log.levels.INFO)
						-- LuaFormatter on
					end
					vim.cmd("LspStart")
				end

				if _G.nvimLspTimeOutStartTimer then
					_G.nvimLspTimeOutStartTimer:stop()
					_G.nvimLspTimeOutStartTimer:close()
					_G.nvimLspTimeOutStartTimer = nil
				end

			end))
		end
	end
})

vim.api.nvim_create_autocmd({"FocusLost"}, {
	desc = "Stop LSP server if window isn't focused",
	group = "LspTimeout",
	callback = function(options)
		-- Clear lsp start timer
		if _G.nvimLspTimeOutStartTimer then
			_G.nvimLspTimeOutStartTimer:stop()
			_G.nvimLspTimeOutStartTimer:close()
			_G.nvimLspTimeOutStartTimer = nil
		end

		local clientsNum = #(require("lsp-timeout.nvim-api").lsp:clients({ buf = options.buf }))
		if not _G.nvimLspTimeOutStopTimer and clientsNum > 0 then
			local configDefault = require("lsp-timeout.config").default
			local config = configDefault:extend(vim.g["lsp-timeout-config"] or {})
			config:validate()
			local timeout = config.stopTimeout

			local uv = vim.uv or vim.loop
			_G.nvimLspTimeOutStopTimer = uv.new_timer()
			_G.nvimLspTimeOutStopTimer:start(timeout, 0, vim.schedule_wrap(function()
				vim.cmd("LspStop")
				if not config.silent then
					-- LuaFormatter off
					vim
					.notify( ("lsp-timeout.nvim: nvim has lost focus, stop %s language servers")
					:format( clientsNum), vim.log.levels.INFO)
					-- LuaFormatter on
				end
				_G.nvimLspTimeOutStopTimer = nil
			end))
		end
	end
})
