describe("lsp-timeout", function()
  describe("Config class", function()
	local Config = require("lsp-timeout.config").Config

	local ignorelist = { "java", "vim", "make" } 
	local config = {}
	config.stopTimeout      = 1
	config.startTimeout     = 2
	config.silent           = true
	config.filetypes        = {}
	config.filetypes.ignore = ignorelist 

    it("instantiate by merging provided argument", function()
	  local config_default = {
		filetypes = {
			ignore = ignorelist
		}
	  }

	  local config = Config:new(config_default)
      assert.are.same(config.filetypes.ignore, ignorelist)
	end)

	describe("should validate config", function()
		it("without errors", function()
			Config:new(config):validate()
		end)
		it("with errors", function()
			assert.has_error(function ()
				Config:new({
					 startTimeout = "string",  -- wrong
					 stopTimeout  = {}
				}):validate()
			end)
		end)
	end)


   --  it("have static tableOfStrings method to check for ", function()
   --    local Config = require("lsp-timeout.config").Config
	  -- assert.is_function(Config.tableOfStrings)
   --  end)

  end)
end)
 

