local uv      = vim.uv or vim.loop
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local auclear = vim.api.nvim_clear_autocmds

-- If this blocks throws an error, you have misconfigured your lsp-timeout
if vim.g["lsp-timeout-config"] then
	local Config = require("lsp-timeout.config").Config
	Config:new(vim.g["lsp-timeout-config"]):validate()
end

local auLSTO   = augroup("LSPTimeout"           , {clear = true})
local auLSTOBL = augroup("LSPTimeoutBufferLocal", {clear = true})

autocmd({"VimEnter"}, {
	desc = "Check if nvim-lspconfig commands are available",
	group = auLSTO,
	once = true,
	callback = function()
		-- We depend on lspconfig utils
		-- If there is a none, clear autcomd
		-- and report an error
		--
		--- Return true if no lsp-config commands are found
		local lspconfigFailed = false
		local lspconfigNoStartCmd = vim.fn.exists(":LspStart") == 0
		local lspconfigNoStoptCmd = vim.fn.exists(":LspStop")  == 0
		if  lspconfigNoStartCmd or lspconfigNoStoptCmd then
			local message =
				"no LspStart command is found. Make sure lsp-config.nvim is installed"
			error(("%s: %s"):format(debug.getinfo(1).source, message))
			lspconfigFailed = true
		end

		local lspcfgUtil        = require("lspconfig.util")
		local lspconfigNoUtilFn = not lspcfgUtil.get_config_by_ft
		if lspconfigNoUtilFn then
			vim.notify("lsp-timeout: lspconfig backend failed, please fill an issue at hinell/lsp-timeout.nvim!", vim.log.levels.ERROR)
			lspconfigFailed = true
		end

		if lspconfigFailed then
			auclear({ group = auLSTO })
			auclear({ group = auLSTOBL })
		end

	end
})

autocmd({"FocusGained"}, {
	desc = "Start LSP servers if application window is focused",
	group = auLSTO,
	callback = function(fgAuEvent)

		local lspPostponeStartup = function(auEvent, clientsToRun)
			-- Clear up lsp stop timer
			if _G.nvimLspTimeOutStopTimer then
				_G.nvimLspTimeOutStopTimer:stop()
				_G.nvimLspTimeOutStopTimer:close()
				_G.nvimLspTimeOutStopTimer = nil
			end

			-- LuaFormatter off
			local Lsp             = require("lsp-timeout.nvim-api").Lsp
			local clientsAttached = Lsp:clients({ buf = auEvent.buf })
			local clientsNum      = #(clientsAttached)
			-- LuaFormatter on

			if not _G.nvimLspTimeOutStartTimer and clientsNum == 0 then
				-- Checks if it's nightly or not
				local configDefault = require("lsp-timeout.config").default
				local config = configDefault:extend(vim.g["lsp-timeout-config"] or {})
				-- Postpone startup
				local timeout = config.startTimeout

				-- ref: https://github.com/neovim/neovim/pull/22846
				_G.nvimLspTimeOutStartTimer = uv.new_timer()
				_G.nvimLspTimeOutStartTimer:start(timeout, 0, vim.schedule_wrap(function()
					if clientsNum < 1 then
						if not config.silent then
							-- LuaFormatter off
							vim
							.notify(
							"lsp-timeout: " .. #clientsToRun
							.. " inactive LSPs found, restarting... "
							, vim.log.levels.INFO)
							-- LuaFormatter on
						end

						-- vim.cmd("LspStart")
						for _, client in ipairs(clientsToRun) do
							client.launch()
						end

					end

					if _G.nvimLspTimeOutStartTimer then
						_G.nvimLspTimeOutStartTimer:stop()
						_G.nvimLspTimeOutStartTimer:close()
						_G.nvimLspTimeOutStartTimer = nil
					end

				end))
			end
		end

		-- clear up previously setup buffer local event listeners
		auclear({ group = auLSTOBL })
		local napi           = require("lsp-timeout.nvim-api")
		local lspcfgUtil     = require("lspconfig.util")

		-- Evalutabe every window/buffer in currently focused tab
		local tabPageWindows = vim.api.nvim_tabpage_list_wins(0)
		local tabPageBuffers = vim.tbl_map(function(winHandle)
			return vim.api.nvim_win_get_buf(winHandle)
		end, tabPageWindows)
		for i, bufferHandle in ipairs(tabPageBuffers) do
			
			-- LuaFormatter off
			local winHandle   = tabPageWindows[i]
			local bufWritable = napi.Buffer:option("modifiable", bufferHandle)
			local bufType     = napi.Buffer:option("filetype", bufferHandle)
			local winIsDiff   = napi.Window:option("diff", winHandle)
			-- LuaFormatter on

			-- Skip readonly and diff windows (diffviews) - there are no LSPs
			if not (bufWritable) or winIsDiff then goto loop_tpb_end end

			-- Startup a FocusGained buffer found in current tab
			if bufferHandle == fgAuEvent.buf then 
				local clientsToRun = lspcfgUtil.get_config_by_ft(bufType)
				if #clientsToRun > 0 then
					lspPostponeStartup(fgAuEvent, clientsToRun)
				end
				goto loop_tpb_end
			end

			-- If a current FocusGained buffer in focused tab is readonly, 
			-- bind writable ones to a disposable lsp startup-handler
			autocmd({"BufEnter"}, {
				once     = true,
				-- pattern  = "*",
				group    = auLSTOBL,
				buffer   = bufferHandle,
				callback = function(auEvent)
					
					local lspcfgUtil = require("lspconfig.util")
					local clientsToRun = lspcfgUtil.get_config_by_ft(vim.bo.filetype)
					if #clientsToRun > 0 then lspPostponeStartup(auEvent, clientsToRun) end
					-- clean up the rest of buffer-local event listeners
					auclear({ group = auLSTOBL })
				end,
				desc = "Start LSP servers if inner window is focused",
			})

			::loop_tpb_end::
		end -- for loop end

	end
})

autocmd({"FocusLost"}, {
	desc = "Stop LSP servers if application window isn't focused",
	group = auLSTO,
	callback = function(auEvent)
		-- Clear up lsp start timer
		if _G.nvimLspTimeOutStartTimer then
			_G.nvimLspTimeOutStartTimer:stop()
			_G.nvimLspTimeOutStartTimer:close()
			_G.nvimLspTimeOutStartTimer = nil
		end

		-- LuaFormatter on
		local napi           = require("lsp-timeout.nvim-api")
		local clients        = napi.Lsp.Clients:new(napi.tabs.current.lsp:clients())
		local clientsNum     = #clients
		local tabPageWindows = vim.api.nvim_tabpage_list_wins(0)
		-- LuaFormatter off
		
	
		if not _G.nvimLspTimeOutStopTimer and clientsNum > 0 then
			local configDefault = require("lsp-timeout.config").default
			local config = configDefault:extend(vim.g["lsp-timeout-config"] or {})
			local timeout = config.stopTimeout

			_G.nvimLspTimeOutStopTimer = uv.new_timer()
			_G.nvimLspTimeOutStopTimer:start(timeout, 0, vim.schedule_wrap(function()
				-- vim.cmd("LspStop")
				clients:stop() 
				if not config.silent then
					-- LuaFormatter off
					local messageOnWindows = #tabPageWindows > 1
						and (" in current tab windows"):format(#tabPageWindows)
						or ""
					vim
					.notify( ("lsp-timeout.nvim: nvim has lost focus, stop %s language servers%s")
					:format(clientsNum, messageOnWindows), vim.log.levels.INFO)
					-- LuaFormatter on
				end
				_G.nvimLspTimeOutStopTimer = nil
			end))
		end
	end
})
