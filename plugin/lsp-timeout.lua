local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local buffer = vim.api.nvim_get_current_buf()
local activeServers = 0
-- TODO: [May 12, 2023] Move into a separate plugin
-- TODO: [June 30, 2023] This needs to take every buffer into account
-- https://github.com/neovim/nvim-lspconfig/pull/2609

require("lsp-timeout.config")

--- Return true if no lsp-config commands are found
augroup("LspTimeout", { clear = true })
autocmd({ "BufEnter" }, {
	desc = "Check if nvim-lspconfig commands are available",
	group = "LspTimeout",
	once = true,
	callback = function()
		if vim.fn.exists(":LspStart") == 0 or vim.fn.exists(":LspStop") == 0 then
			local message = "no LspStart command is found. Make sure lsp-config.nvim is installed"
			error(("%s: %s"):format(debug.getinfo(1).source, message))
			return true
		end
	end,
})

autocmd({ "FocusGained" }, {
	desc = "Rerstart LSP server if buffer is intered",
	group = "LspTimeout",
	callback = function()
		-- Clear lsp stop timer
		if _G.nvimLspTimeOutStopTimer then
			_G.nvimLspTimeOutStopTimer:stop()
			_G.nvimLspTimeOutStopTimer:close()
			_G.nvimLspTimeOutStopTimer = nil
		end

		if not _G.nvimLspTimeOutStartTimer then
			-- Let nvim to start server by default, otherwise postpone startup
			local timeout = vim.g["lsp-timeout-config"].startTimeout
			if not type(timeout) == "number" then
				timeout = 1000 * 10
			end
			_G.nvimLspTimeOutStartTimer = vim.loop.new_timer()
			_G.nvimLspTimeOutStartTimer:start(
				timeout,
				0,
				vim.schedule_wrap(function()
					-- Checks if it's nightly or not
					if not vim.fn.has("nvim-0.9") then
						activeServers = #vim.lsp.get_clients({ bufnr = buffer })
					else
						activeServers = #vim.lsp.get_active_clients({ bufnr = buffer })
					end

					if activeServers < 1 then
						vim.notify(
							("[[lsp-timeout.nvim]]: %s servers found, restarting... "):format(activeServers),
							vim.log.levels.INFO
						)
						vim.cmd("LspStart")
					end

					_G.nvimLspTimeOutStartTimer:stop()
					_G.nvimLspTimeOutStartTimer:close()
					_G.nvimLspTimeOutStartTimer = nil
				end)
			)
		end
	end,
})

autocmd({ "FocusLost" }, {
	desc = "Stop LSP server if window isn't focused",
	group = "LspTimeout",
	callback = vim.schedule_wrap(function()
		-- Clear lsp start timer
		if _G.nvimLspTimeOutStartTimer then
			_G.nvimLspTimeOutStartTimer:stop()
			_G.nvimLspTimeOutStartTimer:close()
			_G.nvimLspTimeOutStartTimer = nil
		end

		-- Checks if it's nightly or not
		if not vim.fn.has("nvim-0.9") then
			activeServers = #vim.lsp.get_clients({ bufnr = buffer })
		else
			activeServers = #vim.lsp.get_active_clients({ bufnr = buffer })
		end

		if not _G.nvimLspTimeOutStopTimer and activeServers > 0 then
			local timeout = vim.g["lsp-timeout-config"].stopTimeout
			if not type(timeout) == "number" then
				timeout = 1000 * 60 * 5
			end

			-- local timeout = 1000 * 10 -- 10 seconds
			_G.nvimLspTimeOutStopTimer = vim.loop.new_timer()
			_G.nvimLspTimeOutStopTimer:start(
				timeout,
				0,
				vim.schedule_wrap(function()
					vim.cmd("LspStop")
					vim.notify(
						("[[lsp-timeout.nvim]]: nvim has lost focus, stop %s language servers"):format(activeServers),
						vim.log.levels.INFO
					)
					_G.nvimLspTimeOutStopTimer = nil
				end)
			)
		end
	end),
})
