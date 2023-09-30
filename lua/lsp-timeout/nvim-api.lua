--- @module nvim
--- Nvim cross-runtime functions 
local M = {}

M.lsp = {}
--- Crossplatofrm function to get current clients;
--- ref: https://github.com/neovim/neovim/pull/24113 
--- @treturn table
function M.lsp:clients(opts)
	-- LuaFormatter off
	-- NVIM v0.10.0
	if vim.lsp.get_clients then
		return vim.lsp.get_clients({
			id     = opts.id,
			name   = opts.name,
			bufnr  = opts.buf,
			method = opts.method
		})
	end
	-- v0.8.0
	-- git di v0.8.0 ac1c23442f runtime/lua/vim/lsp.lua
	if vim.lsp.get_active_clients then
		local NVIM_V080 = vim.fn.has("NVIM-0.8.0") == 1
		if NVIM_V080 then
			return vim.lsp.get_active_clients({
				id     = opts.id,
				name   = opts.name,
				bufnr  = opts.buf
			})
		else
			return vim.lsp.get_active_clients()
		end
	end
	-- NVIM v0.7.2
	-- git di v0.7.2 v0.8.0 runtime/lua/vim/lsp.lua
	if vim.lsp.buf_get_clients then
		return vim.lsp.buf_get_clients(opts.buf)
	end
	-- LuaFormatter on
	vim.notify("lsp-timeout.nvim: it seems like your nvim version is not supporting LSP!", vim.log.levels.ERROR)
end

return M
