# This file is intended to be called by meta Make file 
export NVIM ?=nvim 
export PROJECT_NAME ?=lsp-timeout

include ../make/ts-vimdoc.mk

# Add more files here,
# e.g. $(PROJECT_NAME)-subpage.txt - will be made out of $(PROJECT_NAME)-subpage.md 
.ONESHELL:
tags: $(PROJECT_NAME).txt
	@$(NVIM) --headless -c "helptags ./" -c "q!"

.PHONY: clean
.ONESHELL:
clean:
	rm -v $(PROJECT_NAME).txt ./tags

all: tags
