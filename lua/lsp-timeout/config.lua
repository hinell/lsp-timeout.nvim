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
		error(("%s: table is expected"):format(debug.getinfo(1).source))
		return
	end
	local instance = config or {}
	-- instance.constructor = self
	setmetatable(instance, self._mt)
	return instance
end

--- Validate config
--- @treturn {M.Config}
function M.Config.prototype:validate()
	-- LuaFormatter off
	vim.validate {
		stopTimeout  = { self.stopTimeout , "number" , true },
		startTimeout = { self.startTimeout, "number" , true },
		silent       = { self.silent      , "boolean", true }
	}
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
	  config.stopTimeout  = 1000 * 60 * 5
	  config.startTimeout = 1000 * 10
	  config.silet        = false
-- LuaFormatter on

M.default = M.Config:new(config)

return M
