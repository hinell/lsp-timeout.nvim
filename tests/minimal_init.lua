local path = {}
path.sep = "/"
local ENV_HOME=vim.fn.getenv("HOME")

if vim.fn.has("win32") == 1 then path.sep = "\\" end
 

-- pathss to search plenary.nvim in 
-- lazy.nvim and packer paths are used
-- this is omptimization for local-testing
-- for CI any path can be basically used
-- LuaFormatter off
local plenary_path_arrs = {
	{ ENV_HOME, ".local", "share", "nvim", "lazy", "plenary.nvim"},
	{ ENV_HOME, ".local", "share", "nvim", "site", "pack", "packer", "start", "plenary.nvim"},
	{ ENV_HOME, ".local", "share", "nvim", "site", "pack", "packer", "opt", "plenary.nvim"}
}
-- LuaFormatter on

-- loop got renamed to uv
-- ref: https://github.com/neovim/neovim/pull/22846
local uv = vim.loop or vim.uv
local plenary_path = ""
local plenary_path_tmp = ""
for i, plenary_path_arr in ipairs(plenary_path_arrs) do
	local uv = vim.loop or vim.uv
	plenary_path_tmp = table.concat(plenary_path_arr, path.sep)
	if uv.fs_stat(plenary_path_tmp) then 
		plenary_path = plenary_path_tmp
		break
	end
end

if plenary_path == "" then
	vim.notify(
		"minimal_init.lua: plenary.nvim is not found, please make sure it's installed in lazy.nvim path",
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
