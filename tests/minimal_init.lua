-- Copyright (C) Alex A. Davronov <al.neodim@gmail.com>
-- See LICENSE file or comment at the top of the main file
-- provided along with the source code for additional info
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--
-- Tested in Nvim v0.7.2, v0.8.3, v0.9.2 and v0.10.0 (Oct 2023)
-- Usage.......: nvim --clean --headless --noplugin -u tests/minimal_init.lua \
--			-c "PlenaryBustedDirectory tests/ { sequential = true }"
vim.o.swapfile = false
vim.o.shadafile = ""
vim.o.shada = ""

local path = {}
path.sep = package.config:sub(1, 1)

-- We do not search for plenary path over here
-- and rely entirely on upstream use of this module
local plenary_path = vim.env.PLENARY_PATH
if plenary_path == "" then
    -- LuaFormatter off
	vim.notify(""
	    .. "minimal_init.lua: plenary.nvim is not found,"
		.. "please make sure you have provided PLENARY_PATH="
		.. "environment variable to the nvim running this script",
		vim.log.levels.ERROR)
	vim.cmd("cuit! 1")
	-- LuaFormatter on
end

vim.o.runtimepath = vim.o.runtimepath .. ',' .. plenary_path
vim.cmd("runtime " .. "plugin" .. path.sep .. "plenary.vim")

if vim.fn.exists(":PlenaryBustedDirectory") == 0 then
    vim.notify(
        "minimal_init.lua: Failed to find PlenaryBustedDirectory command. Aborting!",
        vim.log.levels.ERROR)
    vim.cmd("cuit! 1")
end

vim.notify(
    "-------------------------------------------------------------------------------")
vim.notify("minimal_init.lua: testing in ", vim.log.levels.INFO)
vim.cmd("version")
vim.notify("\n")
