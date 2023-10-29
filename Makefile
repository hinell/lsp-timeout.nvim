export SHELL=bash
export NVIM=nvim

export MODULE_NAME ?=lsp-timeout

# Only directories
SUBDIRS=$(wildcard */)

.PHONY: $(SUBDIRS)
.ONESHELL:
$(SUBDIRS):
	# skip the-$(MAKEFLAGS)
	$(MAKE) -C $@ all

all: $(SUBDIRS)

.PHONY: help
.ONESHELL:
help:
	printf "project: $(MODULE_NAME)\n"
	_HELP=""
	_HELP+="help ; print this message\n"
	_DIRS=($(SUBDIRS))
	for dir in $${_DIRS[@]};
	do
		test -f "$${dir}/Makefile" && _HELP+="$${dir} ; setup & buid subidr\n"
	done
	printf "$${_HELP}" | column -s ';' -o '-' -t
