export SHELL ?=bash
export NVIM  ?=nvim

export MODULE_NAME ?=lsp-timeout
export NVIM ?=nvim

# Only directories
SUBDIRS=$(wildcard */)

.PHONY: $(SUBDIRS)
.ONESHELL:
$(SUBDIRS):
	$(MAKE) -$(MAKEFLAGS) -C $@ all

all: $(SUBDIRS)
