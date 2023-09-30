require("lsp-timeout.config")

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
	desc = "Rerstart LSP server if buffer is intered",
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
			local NVIM_V9 = vim.fn.has("nvim-0.9")
			-- Let nvim to start server by default, otherwise postpone startup
			local timeout = vim.g["lsp-timeout-config"].startTimeout
			if not type(timeout) == "number" then timeout = 1000 * 10 end

			-- https://github.com/neovim/neovim/pull/22846
			local uv = NVIM_V9 and vim.uv or vim.loop
			_G.nvimLspTimeOutStartTimer = uv.new_timer()
			_G.nvimLspTimeOutStartTimer:start(timeout, 0, vim.schedule_wrap(function()
				local activeServers = 0
				-- Checks if it's nightly or not
				if not NVIM_V9 then
					-- Got renamed in https://github.com/neovim/neovim/pull/24113
					activeServers = #vim.lsp.get_clients({bufnr = options.buf})
				else
					activeServers = #vim.lsp.get_active_clients({bufnr = options.buf})
				end

				if activeServers < 1 then
					if not vim.g["lsp-timeout-config"].silent then
						vim.notify(
							("[[lsp-timeout.nvim]]: %s servers found, restarting... "):format(
								activeServers), vim.log.levels.INFO)
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

		local activeServers = 0
		if not NVIM_V9 then
			activeServers = #vim.lsp.get_clients({bufnr = options.buf})
		else
			activeServers = #vim.lsp.get_active_clients({bufnr = options.buf})
		end

		if not _G.nvimLspTimeOutStopTimer and activeServers > 0 then
			local NVIM_V9 = vim.fn.has("nvim-0.9")
			local timeout = vim.g["lsp-timeout-config"].stopTimeout
			if not type(timeout) == "number" then timeout = 1000 * 60 * 5 end

			local uv = vim.fn.has("nvim-0.9") and vim.uv or vim.loop
			_G.nvimLspTimeOutStopTimer = uv.new_timer()
			_G.nvimLspTimeOutStopTimer:start(timeout, 0, vim.schedule_wrap(function()
				vim.cmd("LspStop")
				if not vim.g["lsp-timeout-config"].silent then
					vim.notify(
						("[[lsp-timeout.nvim]]: nvim has lost focus, stop %s language servers"):format(
							activeServers), vim.log.levels.INFO)
				end
				_G.nvimLspTimeOutStopTimer = nil
			end))
		end
	end
})
