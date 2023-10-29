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
#
# Description: Find path to a locally installed nvim-plugins, or install otherwise in native path
# returned path may be used as a dependency in upstream targets; see example below

## @summary Find path to a plugin named $(1) in dirs common to nvim & nvim package managers
define nvim_plugin_path_find
PLUGIN_NAME=$(1);
PLUGIN_NAME_BASE="$${PLUGIN_NAME//%.*}";
PATHS=(
	$${HOME}/.local/share/nvim/site/pack/opt/pack/$${PLUGIN_NAME_BASE}/start/$${PLUGIN_NAME}
	$${HOME}/.local/share/nvim/site/pack/packer/start/$${PLUGIN_NAME}
	$${HOME}/.local/share/nvim/lazy/$${PLUGIN_NAME}
);

declare OUTPUT;
for DIR in $${PATHS[@]};
do
	test -d "$${DIR}" && OUTPUT="$${DIR}";
done ;
[[ -z "$${OUTPUT}" ]] && echo $${PATHS[0]} || echo $${OUTPUT};
endef

## @summary Function creates a PLUGIN_<NAME>_PATH and auto-downloads if it's missing or reuse existin ginstallation for common package managers such as packer.nvim or lazy.nvim
## @usage
## SHELL=bash
## $(eval $(call neovim-plugin-install-fn,PLUGIN_FOO_PATH,plugin-foo.nvim,https://github.com/user/plugin-foo.nvim))
## my_custom_target: $(PLUGIN_FOO_PATH)
## @example
## SHELL=bash
## $(eval $(call nvim_plugin_path,NVIM_TS_PATH,nvim-treesitter,https://github.com/nvim-treesitter/nvim-treesitter))
## 	$(eval $(call nvim_plugin_path,NVIM_PLENARY_PATH,plenary.nvim,https://github.com/nvim-lua/plenary.nvim))
## 	$(info path to nvim-treesitter -> $(NVIM_TS_PATH))
## 	$(info path to nvim-plenary -> $(NVIM_PLENARY_PATH))
## all: $(NVIM_TS_PATH) $(NVIM_PLENARY_PATH)
##
## @param VAR_NAME - variable name for nvim plugin path that you will use as dependeencies in targets, e.g. PLUGIN_FOO_PATH
## @param plugin_name - plugin's original name e.g. ohow it on github / gitlab / etc.: plugin-foo.nvim
## @param plugin_url - plugin's URI on a public git repository to be cloned by git when the PLUGIN_NAME_PATH is not found on a aystem
define nvim_plugin_path
ifeq ($$(notdir $$(SHELL)),sh)
$$(error neovim-plugin: SHELL= should be bash for this function!)
endif

# We have to use make script to actaully find whether given path exists
# then it can be used as a dependency in upstream targets
.ONESHELL:
.PHONY: $$($(1))
$(1)=$$(shell $$(call nvim_plugin_path_find,$(2)))
$$($(1)):
	# ping google public DNS to check if connected to WAN
	nc -4 -w 1 8.8.8.8 53 || {
		echo -e "$$(tput setaf 5)info:$$(tput op): github.com is unreachable, checkout your connection"
		exit 0
	}
	if test -d "$$(@)" ;
	then
		echo "$$@ IS     found, updating from: $(3)."
		git -C $$(@) pull origin master;
	else
		echo "$$@ IS NOT found, pulling from: $(3)."
		mkdir -vp $$(@) ;
		git clone --no-tags --depth=1 --single-branch '$(3)' "$$(@)";
	fi
endef
