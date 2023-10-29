export SHELL=bash
# Neovim versions to test; required by following modules
NEOVIM_VERSIONS=v0.7.2 v0.8.3 v0.9.2 nightly
include ../tools/make/neovim-install.mk # provides: $(HOME)/.neovim/%/bin/nvim
_path_to_nvim_fn ?= $(HOME)/.neovim/$(1)/bin/nvim
include ../tools/make/plenary-setup.mk  # provides: $(patsubst %,test-ubuntu-%,$(NEOVIM_VERSIONS))

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

