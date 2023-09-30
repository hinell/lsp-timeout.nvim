-- Default config
--- Configuration class
--- @class M.Config
local M = {}
M.Config = { prototype = { ctx = {}, constructor = M.Config } }
M.Config._mt = {
	__index = function(table, key)
		if key == "constructor" then return M.Config end
		return table.constructor.prototype[key]
			or	table.constructor.super
			and table.constructor.super.prototype[key]
	end
}

--- Creates new instance static method)
--- @tparam  Table containing area
function M.Config:new (config)
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
function M.Config.prototype:validate ()
	-- last parameter: true to make nil valid 
	vim.validate {
		stopTimeout  = { self.stopTimeout , "number" , false },
		startTimeout = { self.startTimeout, "number" , false },
		silent       = { self.silent      , "boolean", false }
	}
	return self
end

--- Extend current config and return new instance 
--- @tparam {table} config
--- @treturn {M.Config}
function M.Config.prototype:extend (config)
	local configNew = vim.tbl_extend("force", self, config)
	return self.constructor:new(configNew)
end

M.default = M.Config:new({
	stopTimeout  = 1000 * 60 * 5,
	startTimeout = 1000 * 10,
	silent       = false
})

return M
