# Copyright (C) 2023- Alex A. Davronov <al.neodim@gmail.com>
# See LICENSE file or comment at the top of the main file
# provided along with the source code for additional info
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Description: export rules to convert markdown to vimhelp by using ts-vimdoc lua module
# requires nvim-treesitter
# usage:
# 	include make/ts-vimdoc.mk.in
# 	all: index.txt

ifneq ($(notdir $(SHELL)),bash)
$(info "$(SHELL)")
$(error nvim-plugin-path: SHELL= should be bash for this function, got $(SHELL) instead.!)
endif

# required for plugins bootstrapping
include ../tools/make/neovim-plugin.mk
$(eval $(call nvim_plugin_path,NVIM_TREESITTER_PATH,nvim-treesitter,https://github.com/nvim-treesitter/nvim-treesitter))
$(eval $(call nvim_plugin_path,NVIM_TS_VIMDOC_PATH,ts-vimdoc.nvim,https://github.com/ibhagwan/ts-vimdoc.nvim))

.ONESHELL:
%.txt: %.md | $(NVIM_TREESITTER_PATH) $(NVIM_TS_VIMDOC_PATH)
	PROJECT_NAME="$(@)"
	_lua_gen_doc(){
		cat<<-EOL
			vim.opt.runtimepath:append('$(NVIM_TREESITTER_PATH)')
			vim.opt.runtimepath:append('$(NVIM_TS_VIMDOC_PATH)')
			vim.cmd([[runtime! plugin/**/*.{lua,vim}]])
			local ts = require("nvim-treesitter.configs")
			ts.setup({})
			vim.cmd([[TSUpdateSync markdown]])
			vim.cmd([[TSUpdateSync markdown_inline]])

			require('ts-vimdoc').docgen({
				input_file='$<',
				output_file = '$@',
				project_name="$${PROJECT_NAME%%.txt}",
			})
			os.exit(0)
		EOL
	}

	$(NVIM) --clean --headless --noplugin -u NONE -l <(_lua_gen_doc)

	command -v unicode-emoji-remove.sh &> /dev/null || {
		# Use 2> error.log to read the output of the command
		echo -e "$0: $(tput setaf 1)error:$(tput op) unicode-emoji-remove.sh is nout found; install it from" \
				"https://github.com/hinell/dotfiles/blob/main/bash-scripts/unicode-emoji-remove.sh" \
		> /dev/stderr;
	}
	test -f "$<" && unicode-emoji-remove.sh -i $@
	# strip <br> tags
	sed -i -E -e 's/<\/?br\/?>\s*/\n/g' $@
