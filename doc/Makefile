# This file is intended to be called by meta Make file 
export NVIM ?=nvim 
export PROJECT_NAME ?=lsp-timeout

# ts-vimdoc generate vimhelp from markdown 
.ONESHELL:
%.txt: %.md
	echo "WTF?"
	pwd
	PROJECT_NAME="$(@)"
	$(NVIM) --headless -E -c "
		lua require('ts-vimdoc').docgen({
			input_file='$<',
			output_file = '$@',
			project_name=\"$${PROJECT_NAME%%.txt}\",
		})
		os.exit(0)
	"
	command -v unicode-emoji-remove.sh &> /dev/null || {
		# Use 2> error.log to read the output of the command 
		echo -e "$0: $(tput setaf 1)error:$(tput op) unicode-emoji-remove.sh is nout found; install it from" \
				"https://github.com/hinell/dotfiles/blob/main/bash-scripts/unicode-emoji-remove.sh" \
		> /dev/stderr;
	}
	test -f "$<" && unicode-emoji-remove.sh -i $@
	# strip <br> tags
	sed -i -E -e 's/<\/?br\/?>\s*/\n/g' $@

.ONESHELL:
tags: $(PROJECT_NAME).txt
	@$(NVIM) --headless -c "helptags ./" -c "q!"

.PHONY: clean
.ONESHELL:
clean:
	rm -v $(PROJECT_NAME).txt ./tags

all: tags
