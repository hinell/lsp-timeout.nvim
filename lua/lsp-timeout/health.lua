local M = {}

local health = vim.health or require "health"

-- LuaFormatter off
-- compat: nvim v0.10.0
if vim.health.report_error then
	vim.health.error = vim.health.error or vim.health.report_error
	vim.health.info  = vim.health.info or vim.health.report_info
	vim.health.ok    = vim.health.ok or vim.health.report_ok
	vim.health.start = vim.health.start or vim.health.report_start
	vim.health.warn  = vim.health.warn or vim.health.report_warn
end
-- LuaFormatter on

M.plugin_name = "lsp-timeout"
M.check = function()
	health.start(M.plugin_name)

	-- Test for NVIM version
	if vim.fn.has "nvim-0.8.3" ~= 1 then
		health.error(M.plugin_name .. " requires Neovim >=v0.8.3")
	end

	if vim.fn.executable "node" == 0 then
		health.warn("NO `node` executable found", "install node.js first")
	else
		local handle = io.popen("node --version")
		local result = handle:read("*a")
		local version = vim.split(result, "\n")[1]
		-- LuaFormatter off
        health.ok("`node` " .. version .. " is found (needed for `:TSInstallFromGrammar`)")
		-- LuaFormatter on
		handle:close()
	end

	-- local someCheck = true
	-- if someCheck then
	-- 	health.ok("Setup is correct")
	-- else
	-- 	health.error("Setup is incorrect")
	-- end

	local nulllsInstalled, nullLs = pcall(require, "null-ls")
	if nulllsInstalled then
		-- LuaFormatter off
		vim.health.warn("using null-ls (or none-ls) - it got deprecated" ..
			" consult troubeshooting guide in doc",
			"switch to alternatives like efm-langserver; null-is or none-ls is buggy")
		-- LuaFormatter on
	else
		vim.health.ok("`null-ls` is not installed")
		vim.health.ok("`none-ls` is not instalsed")
	end

	local navicInstalled, navic = pcall(require, "nvim-navic")
	if navicInstalled then

		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			if vim.b[bufnr].navic_client_name then
				-- LuaFormatter off
				vim.health.warn(
					"navic is not attached to any LSP client",
					" consult troubeshooting guide in doc"
				)
				-- LuaFormatter on
			end
		end
	end

	local lspconfigInstalled, lspconfig = pcall(require, "lspconfig")
	local tstoolsInstalled, tstools = pcall(require, "typescript-tools")
	if lspconfigInstalled then
		if type(require("lspconfig.configs")["typescript-tools"]) == "table"
		then
			vim.health.ok("`typescript-tools` is setup")
		else
			-- LuaFormatter off
			vim.health.warn(
				"typescript-tools are not setup",
				" consult troubeshooting guide in doc"
			)
			-- LuaFormatter on
		end
	end

end

return M
