# Copyright (C) 2023- Alex A. Davronov <al.neodim@gmail.com>
# See LICENSE file or comment at the top of the main file
# provided along with the source code for additional info
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# ts-vimdoc: convert markdown to vimhelp
# requires nvim-treesitter
# usage:
# 	includ make/ts-vimdoc.mk
# 	all: index.txt
.ONESHELL:
%.txt: %.md
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
