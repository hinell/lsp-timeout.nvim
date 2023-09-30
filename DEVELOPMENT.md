# DEVELOPMENT
This project is developed by using various developer tools. For runtime dependencies see [BUILD](#BUILD) subsection.
* [GIT SCM/VCS](https://git-scm.com/)
* IDE/Editor: [Neovim], Vim, KDE Kate, VS Code etc.
* System: Linux-based, e.g. Debian (U/Kubuntu) or alike
* Shell: zsh or bash
* others...	

[Neovim]: https://github.com/neovim/neovim

> _See also: .md files in \`src/\` folder._ 
## GIT WORKFLOW
It's highly likely that this project is going to be
[force-pushed](https://git-scm.com/docs/git-push#Documentation/git-push.txt)
and aggressively [squash-rebased](https://git-scm.com/docs/git-rebase) into specific semver versions.
Take into account this fact when making a PR: it is likely render your
base-commits obsolete.

## BUILD
### Dev dependencies
* **[GNU Make](https://www.gnu.org/software/make/)** - required for `make` command; should be already installed on *nix systems
* **[ts-vimdoc](https://github.com/ibhagwan/ts-vimdoc.nvim)** - the tool is used to generate `doc/*.txt` files from `*.md`
* **[LuaFormatter](https://github.com/Koihik/LuaFormatter)** - lua code formatter; much faster than `stylua` 

### Runtime dependencies

<!-- ## TEST -->
<!---->
<!-- ## PUBLISH -->


----
September 28, 2023</br>
Copyright © 2023 - Alexander Davronov, et.al.<br>
