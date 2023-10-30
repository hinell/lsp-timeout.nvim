-- Default config
--- Configuration class
--- @class M.Config
local M = {}
M.Config = {prototype = {ctx = {}, constructor = M.Config}}
M.Config._mt = {
	__index = function(table, key)
		-- LuaFormatter off
		if key == "constructor" then return M.Config end
		return table.constructor.prototype[key]
			or	table.constructor.super
			and table.constructor.super.prototype[key]
		-- LuaFormatter on
	end
}

--- Creates new instance static method)
--- @tparam  Table containing area
function M.Config:new(config)
	if type(config) ~= "table" then
		error(("table is expected"):format(debug.getinfo(1).source), 2)
		return
	end
	local instance = config or {}
	-- instance.constructor = self
	setmetatable(instance, self._mt)
	return instance
end

--- Checks if a table contains a list of strings; false if empt
--- @param table table|nil
--- @return boolean
M.Config.tableOfStrings = function(table)
	local tableIsList  = type(table) == "table" and vim.tbl_islist(table)
	if tableIsList then
		local value = nil 
		for i = 1, #table do
			value = table[i]
			if type(value) ~= "string" then
				return false
			end
		end
		return true
	else
		return false
	end
end

--- Validate config
--- @treturn {M.Config}
function M.Config.prototype:validate()

	-- LuaFormatter of
	if not ((self.stopTimeout == nil) or type(self.stopTimeout) == "number") then
		error("lsp-timeout.config.stopTimeout: number is expected, got "
		.. type(self.stopTimeout), 2)
	end

	if not (self.startTimeout == nil or type(self.startTimeout) == "number") then
		error("lsp-timeout.config.startTimeout: number is expected, got "
		.. type(self.stopTimeout), 2)
	end

	if not (self.silent == nil or type(self.silent) == "boolean") then
		error("lsp-timeout.config.silent: boolean is expected, got "
		.. type(self.stopTimeout), 2)
	end

	if self.filetypes ~= nil then
		if (vim.tbl_islist(self.filetypes) and not vim.tbl_isempty(self.filetypes))
		or not self.filetypes.ignore then
			error("lsp-timeout.config.filetypes: { ignore = { .. } } is expected, got "
			.. vim.inspect(self.filetypes), 2)
		end
	end

	if self.filetypes ~= nil then
		if type(self.filetypes) ~= "table" then
			error("lsp-timeout.config.filetypes: table is expected, got "
			.. type(self.filetypes), 2)
		else
			if  self.filetypes.ignore ~= nil
				and not vim.tbl_isempty(self.filetypes.ignore)
				and not self.constructor.tableOfStrings(self.filetypes.ignore)
			then
				error("lsp-timeout.config.filetypes.ignore: table of strings is expected, got "
				.. vim.inspect(self.filetypes.ignore), 2)
			end
		end
	end

	return self
	-- LuaFormatter on
end

--- Extend current config and return new instance 
--- @tparam table config
--- @treturn M.Config
function M.Config.prototype:extend(config)
	local configNew = vim.tbl_deep_extend("force", self, config)
	return self.constructor:new(configNew)
end

-- LuaFormatter off
local config = {}
	  config.stopTimeout      = 1000 * 60 * 5
	  config.startTimeout     = 1000 * 10
	  config.silent           = false
	  config.filetypes        = {}
	  config.filetypes.ignore = {}
-- LuaFormatter on

M.default = M.Config:new(config):validate()

return M
