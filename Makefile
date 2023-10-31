export SHELL=/usr/bin/bash

export PROJECT_NAME ?=lsp-timeout
export NVIM ?=nvim

# Only directories
SUBDIRS=$(wildcard */)

.PHONY: $(SUBDIRS)
.ONESHELL:
$(SUBDIRS):
	$(MAKE) -$(MAKEFLAGS) -C $@ all

all: $(SUBDIRS)
