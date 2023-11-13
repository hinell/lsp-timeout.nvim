# tests/Makefile.plenary
# tests: setup plenary.nvim to test tests specs in various nvim versions
#-------------------------------------
# Find path to a plenary.nvim in differet package manager paths
# this is used for local testing; in CI it's going to downloaded to a shortest path
DEP_PLENARY_PATH  = $(or $(shell _path=$(HOME)/.local/share/nvim/site/pack/opt/pack/plenary/start/plenary.nvim; test -d $${_path} && echo "$${_path}"))
DEP_PLENARY_PATH  = $(or $(shell _path=$(HOME)/.local/share/nvim/site/pack/packer/start/plenary.nvim; test -d $${_path} && echo "$${_path}"))
DEP_PLENARY_PATH  = $(or $(shell _path=$(HOME)/.local/share/nvim/lazy/plenary.nvim; test -d $${_path} && echo "$${_path}"))
DEP_PLENARY_PATH := $(or $(DEP_PLENARY_PATH), $(HOME)/.local/share/nvim/lazy/plenary.nvim)

.ONESHELL:
.PHONY: $(DEP_PLENARY_PATH)
$(DEP_PLENARY_PATH):
	# ping google public DNS to check if connected to WAN
	nc -4 -w 1 8.8.8.8 53 || {
		echo -e "$(tput setaf 5)info:$(tput op): github.com is unreachable, checkout your connection"
		exit 0
	}
	if test -d "$(@)" ;
	then
		git -C "$(@)" pull origin master
	else
		mkdir -vp $@
		git clone --no-tags --depth=1 --single-branch 'https://github.com/nvim-lua/plenary.nvim.git' "$(@)"
	fi

# test: setup neovim versions for testing
#-------------------------------------
# Neovim versions to test
NEOVIM_VERSIONS=v0.7.2 v0.8.3 v0.9.2 nightly

include ../make/neovim-install.mk

# tests for specific neovim versions
# test-ubuntu-NVIM_VERSION
# test-ubuntu-nightly etc.
.PHONY: $(patsubst %,test-ubuntu-%,$(NEOVIM_VERSIONS))
.ONESHELL:
$(patsubst %,test-ubuntu-%,$(NEOVIM_VERSIONS)): test-ubuntu-%: $(HOME)/.neovim/%/bin/nvim | $(DEP_PLENARY_PATH)
	cd ..
	if test -s tests/minimal_init.lua ;
	then
		PLENARY_PATH=$(DEP_PLENARY_PATH) \
		VIM="$${HOME}/.neovim/$(*)/share/nvim/runtime" \
		$(HOME)/.neovim/$(*)/bin/nvim \
		--headless --noplugin -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/ { sequential = false }"
	else
		echo -e "$(@): $$(tput setaf 1)error:$$(tput op) tests/minimal_init.lua is not found. Aborting!" > /dev/stderr
		exit 1
	fi

# tests by using system-installed nvim
.PHONY: test-current
.ONESHELL:
test-current: | $(DEP_PLENARY_PATH)
	cd ..
	command -v nvim && {
		PLENARY_PATH=$(DEP_PLENARY_PATH) \
		$(NVIM) --clean --headless --noplugin -u tests/minimal_init.lua \
			-c "PlenaryBustedDirectory tests/ { sequential = true }"
	}

# all tests
.PHONY: test
.ONESHELL:
test: $(patsubst %,test-ubuntu-%,$(NEOVIM_VERSIONS))

.PHONY: clean
.ONESHELL:
clean:
	# nightly is often updated
	rm -vrd $(HOME)/.neovim/nightly

all: test
