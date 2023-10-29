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

# Description: setup plenary.nvim to test tests specs in various nvim versions
# Usage: use in conjunction with neovim-install.mk
#  re-define the following function with a pattern for VERSION substitution, e.g:
# _path_to_nvim_fn ?=$(HOME)/.neovim/$(1)/bin/nvim
# mytarget: $(call _path_to_nvim_fn,%)

ifeq ($(_path_to_nvim_fn),)
$(error "plenary-setup: _path_to_nvim_fn is required;\
it should expand to a path with a % pattern variable for neovim versions substitution!")
endif

ifeq ($(NEOVIM_VERSIONS),)
$(error "plenary-setup: NEOVIM_VERSIONS variable should be setup to list of neovim versions!")
endif

ifneq ($(notdir $(SHELL)),bash)
$(info "$(SHELL)")
$(error nvim-plugin-path: SHELL= should be bash for this function, got $(SHELL) instead.!)
endif

include ../tools/make/neovim-plugin.mk
$(eval $(call nvim_plugin_path,NVIM_PLENARY_PATH,plenary.nvim,https://github.com/nvim-lua/plenary.nvim))

# OUTPUT targets, e.g.:
# tests for specific neovim versions
# test-ubuntu-NVIM_VERSION
# test-ubuntu-nightly etc.
.PHONY: $(patsubst %,test-ubuntu-%,$(NEOVIM_VERSIONS))
.ONESHELL:
$(patsubst %,test-ubuntu-%,$(NEOVIM_VERSIONS)): test-ubuntu-%: $(call _path_to_nvim_fn,%) | $(NVIM_PLENARY_PATH)
	cd ..
	if test -s tests/minimal_init.lua ;
	then
		PLENARY_PATH=$(NVIM_PLENARY_PATH) \
		VIM="$${HOME}/.neovim/$(*)/share/nvim/runtime" \
		$(HOME)/.neovim/$(*)/bin/nvim \
		--headless --noplugin -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/ { sequential = false }"
	else
		echo -e "$(@): $$(tput setaf 1)error:$$(tput op) tests/minimal_init.lua is not found. Aborting!" > /dev/stderr
		exit 1
	fi

# OUTPUT targets, e.g.:
# tests by using system-installed nvim
.PHONY: test-current
.ONESHELL:
test-current: | $(NVIM_PLENARY_PATH)
	cd ..
	command -v nvim && {
		PLENARY_PATH=$(NVIM_PLENARY_PATH) \
		$(NVIM) --clean --headless --noplugin -u tests/minimal_init.lua \
			-c "PlenaryBustedDirectory tests/ { sequential = true }"
	}
