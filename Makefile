NVIM=nvim
PROJECT_NAME=lsp-timeout

all: doc/tags

.PHONY:
doc/tags: doc/$(PROJECT_NAME).txt
	@$(NVIM) --headless -c "helptags doc/" -c "exit"

# ts-vimdoc generate vimhelp from markdown 
.ONESHELL:
doc/$(PROJECT_NAME).txt: doc/index.md
	@$(NVIM) --headless -E -c "
		lua require('ts-vimdoc').docgen({
			input_file='doc/index.md',
			output_file = '$@',
			project_name='$(PROJECT_NAME)',
		})
		os.exit()
	"
	:
	@command -v unicode-emoji-remove.sh &> /dev/null || {
		# Use 2> error.log to read the output of the command
		echo -e "$0: $(tput setaf 1)error:$(tput op) unicode-emoji-remove.sh is nout found; install it from @gtihub:hinell/dotfiles" > /dev/stderr;
	}
	@unicode-emoji-remove.sh -i $@
	@sed -E -i -e 's/<\/br>\s*/\n/' $@
