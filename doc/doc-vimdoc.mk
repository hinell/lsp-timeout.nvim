# This file is intended to be included by root project Makefile!

.PHONY:
doc/tags: doc/$(PROJECT_NAME).txt
	@$(NVIM) --headless -c "helptags doc/" -c "exit"

# ts-vimdoc generate vimhelp from markdown 
.SILENT:
.ONESHELL:
doc/$(PROJECT_NAME).txt: doc/index.md
	$(NVIM) --headless -E -c "
		lua require('ts-vimdoc').docgen({
			input_file='doc/index.md',
			output_file = '$@',
			project_name='$(PROJECT_NAME)',
		})
		os.exit()
	"
	command -v unicode-emoji-remove.sh &> /dev/null || {
		# Use 2> error.log to read the output of the command 
		echo -e "$0: $(tput setaf 1)error:$(tput op) unicode-emoji-remove.sh is nout found; install it from" \
				"https://github.com/hinell/dotfiles/blob/main/bash-scripts/unicode-emoji-remove.sh" \
		> /dev/stderr;
	}
	test -f $< && unicode-emoji-remove.sh -i $@
	# strip <br> tags
	sed -i -E -e 's/<\/?br\/?>\s*/\n/g' $@

.PHONY: doc-clean
.ONESHELL:
doc-clean:
	rm -v doc/$(PROJECT_NAME).txt doc/tags

all: doc/tags
clean: doc-clean
