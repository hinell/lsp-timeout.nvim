local path = {}
path.sep = "/"
if vim.fn.has("win32") == 1 then path.sep = "\\" end

-- We do not search for plenary path over here
-- and rely entirely on upstream use of this module
local plenary_path=vim.env.PLENARY_PATH
if plenary_path == "" then
	vim.notify(
		"minimal_init.lua: plenary.nvim is not found,"
		.. "please make sure you have provided nvim with PLENARY_PATH= environment variable ",
		vim.log.levels.ERROR)
	vim.cmd("q!")
end

vim.o.runtimepath = vim.o.runtimepath .. ',' .. plenary_path
vim.cmd("runtime " .. "plugin" .. path.sep .. "plenary.vim")

if vim.fn.exists(":PlenaryBustedDirectory") == 0 then
	vim.notify(
		"minimal_init.lua: Failed to find PlenaryBustedDirectory command. Aborting!",
		vim.log.levels.ERROR)
	vim.cmd("q!")
end

vim.notify("-------------------------------------------------------------------------------")
vim.notify("minimal_init.lua: testing in ", vim.log.levels.INFO)
vim.cmd("version")
vim.notify("\n")
