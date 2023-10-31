# This file is intended to be called by meta Make file 
export NVIM ?=nvim 

# tests: setup plenary.nvim
#-------------------------------------
.ONESHELL:
.PHONY: $(HOME)/.local/share/nvim/lazy/plenary.nvim
$(HOME)/.local/share/nvim/lazy/plenary.nvim:
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

# Use globally available folder for neovim
$(HOME)/.neovim/:
	mkdir -vp $@

# (GNU Make static patter is used)
# ref: https://www.gnu.org/software/make/manual/html_node/Static-Usage.html
# $HOME/.neovim/NVIM_VERSION/bin/nvim
# $HOME/.neovim/nightly/bin/nvim
# $HOME/.neovim/v0.9.2/bin/nvim
.ONESHELL:
$(patsubst %,$(HOME)/.neovim/%/bin/nvim,$(NEOVIM_VERSIONS)): $(HOME)/.neovim/%/bin/nvim: | $(HOME)/.neovim/
	echo "Downloading Nvim $(*) to \$$HOME/.neovim/$(*)/"
	mkdir -vp "$${HOME}/.neovim/$(*)"
	_ASSET_NAME="$(*)/nvim-linux64.tar.gz"
	curl -sL "https://github.com/neovim/neovim/releases/download/$${_ASSET_NAME}" | tar --strip-components=1 -C "$${HOME}/.neovim/$(*)/" -xzf -


# tests for specific neovim versions
# test-ubuntu-NVIM_VERSION
# test-ubuntu-nightly etc.
.PHONY: $(patsubst %,test-ubuntu-%,$(NEOVIM_VERSIONS))
.ONESHELL:
$(patsubst %,test-ubuntu-%,$(NEOVIM_VERSIONS)): test-ubuntu-%: $(HOME)/.neovim/%/bin/nvim | $(HOME)/.neovim/ $(HOME)/.local/share/nvim/lazy/plenary.nvim
	cd ..
	if test -s tests/minimal_init.lua ;
	then
		VIM="$${HOME}/.neovim/$(*)/share/nvim/runtime" $(HOME)/.neovim/$(*)/bin/nvim --headless --noplugin -u tests/minimal_init.lua \
			-c "PlenaryBustedDirectory tests/ { sequential = false }"
	else
		echo -e "$(@): $$(tput setaf 1)error:$$(tput op) tests/minimal_init.lua is not found. Aborting!" > /dev/stderr
		exit 1
	fi

# tests by using system-installed nvim
.PHONY: test-current
.ONESHELL:
test-current: | $(HOME)/.local/share/nvim/lazy/plenary.nvim
	cd ..
	command -v nvim && {
		nvim --clean --headless --noplugin -u tests/minimal_init.lua \
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
