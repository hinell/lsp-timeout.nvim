--- @module nvim
--- Nvim cross-runtime generic functions 
local M = {}

M.Buffer = {}

--- Cross-runtime option fetcher 
function M.Buffer:option(name, bufHandle)
	if vim.api.nvim_get_option_value then
		return vim.api.nvim_get_option_value(name, { buf = bufHandle })
	elseif vim.api.nvim_buf_get_option then
		-- nvim v0.7.2
	   return vim.api.nvim_buf_get_option(bufHandle, "name")
	else
		vim.notify("your nvim version is not supported", vim.log.levels.ERROR)
	end
end

--- Cross-runtime option fetcher 
M.Window = {}
function M.Window:option(name, winHandle)
	if vim.api.nvim_get_option_value then
		return vim.api.nvim_get_option_value(name, { win = winHandle })
	elseif vim.api.nvim_buf_get_option then
		-- nvim v0.7.2
	   return vim.api.nvim_win_get_option(winHandle, "name")
	else
		vim.notify(
		"your nvim version is not supported, please fill an issue"
		, vim.log.levels.ERROR)
	end
end

M.Lsp = {}
--- @class LspTimeOutLspConfig
--- @field id number|nil
--- @field buf number|nil
--- @field name string|nil
--- @field method string|nil

--- Crossplatofrm function to get current clients;
--- ref: https://github.com/neovim/neovim/pull/24113 
--- @param opts LspTimeOutLspConfig
--- @treturn table
function M.Lsp:clients(opts)
	-- LuaFormatter off
	-- NVIM v0.10.0
	if vim.lsp.get_clients then
		return vim.lsp.get_clients({
			id     = opts.id,
			bufnr  = opts.buf,
			name   = opts.name,
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
				bufnr  = opts.buf,
				name   = opts.name,
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


--- Wrapper for table of LSP clients
--- @class M.Lsp.Clients
M.Lsp.Clients = { prototype = { ctx = {}, constructor = M.Lsp.Clients } }
M.Lsp.Clients._mt = {
	__index = function(table, key)
		if key == "constructor" then return M.Lsp.Clients end
		return table.constructor.prototype[key]
			or	table.constructor.super
			and table.constructor.super.prototype[key]
	end
}

--- Creates new instance static method)
--- @param clients table
function M.Lsp.Clients:new (clients)
	vim.validate({
		clients = { clients, "table", false }
	 })
	local instance = vim.list_extend({}, clients)
	instance.constructor = self
	setmetatable(instance, self._mt)
	return instance
end


--- Stop list of currently held clients 
--- @treturn nil
function M.Lsp.Clients.prototype:stop (force, rpcTerminate)
	for _, client in ipairs(self) do
		client.stop(force)
		if rpcTerminate then
			client.rpc.terminate()
		end
	end
end

-- Basic namespaces
M.tabs                         = {}
M.tabs.current                 = {}
M.tabs.current.lsp             = {}
M.tabs.current.buffers         = {}
M.tabs.current.buffers.current = { lsp = {} }

--- Return clients for current tab 
--- @treturn table
function M.tabs.current.lsp:clients()
	local tabPageWindows = vim.api.nvim_tabpage_list_wins(0)
	local tabPageBuffers = vim.tbl_map(function(winHandle)
		return vim.api.nvim_win_get_buf(winHandle)
	end, tabPageWindows)
	local clients = {}
	local clientsMap = {}
	for _, bufHandle  in ipairs(tabPageBuffers) do
		local bufferLspClients = M.Lsp:clients({ buf = bufHandle })
		for _, client  in ipairs(bufferLspClients) do
			if not clientsMap[client.id] then
				clientsMap[client.id] = client
				table.insert(clients, client)
			end
		end
	end
	clientsMap = nil
	return clients
end

return M
