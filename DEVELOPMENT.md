# DEVELOPMENT

## OVERVIEW
This project is developed by using various developer systems and tools:
* [GIT SCM/VCS](https://git-scm.com/)
* IDE/Editor: [Neovim], Vim, KDE Kate, VS Code etc.
* Shell: [zsh] / bash
* System: Unix/Linux-based, e.g. Debian (Ubuntu/[Kubuntu]) or alike ; MS Windows is not advised
* others...

[Neovim]: https://github.com/neovim/neovim 'Powerful terminal editor'
[zsh]: https://zsh.sourceforge.io/ 'A shell designed for interactive use'
[Kubuntu]: https://kubuntu.org/ 'Linux Distro based on Debian Operating System'

### CONVENTIONS

<p align="left"><i>Less is more - Chilon of Sparta (6 BC)</i></p>

<dl>
    <dt>Brevity</dt>
    <dd>The code and docs must be brief / quick / easy to read; unavoidable complexities are allowed</dd>
    <dt>Inexpensiveness</dt>
    <dd>Requirement of zero maintenance and self-sufficiency is paramount; automation is the future</dd>
    <dt>Resilience</dt>
    <dd>No breaking changes or complexity are allowed unless cost/benefit ratio tends to be zero</dd>
</dl>


#### GIT WORKLOW
* Aggressive [force-pushing](https://git-scm.com/docs/git-push#Documentation/git-push.txt) and [squash-rebasing](https://git-scm.com/docs/git-rebase) into specific [semver] versions (AFPSR)
* Consequently, tags are guaranteed to be dropped / hard reset in critical cases later
* Exceptions to the above rule: stable tags for package managers prohibiting version replacement
* The above implies that any [upstream] commits pulled down may become obsolete very fast

##### Tag naming conventions
* `latest` - latest released version
* `vX.Y.Z`  - version, per [semver]
* `nighlty` - testing build

##### Branch naming convention
* `main` - main/release line branch
* `dev` - active development branch;  don't use for end-product
* `release/X.Y.Z` - next release; tightly coupled to `main`; very short halflife

##### Commits messages convention
Commits messages follow [Conventional Commits] spec

[semver]: https://github.com/semver/semver 'Semantic version'
[upstream]: https://docs.github.com/en/get-started/quickstart/github-glossary#upstream 'Gighub glossary: upstream'
[Conventional Commits]: https://github.com/conventional-commits/conventionalcommits.org 'The conventional commits specification'

## DEVELOP

This project approximates the following working tree hierarchy (similar to [Folder Structure Conventions](https://github.com/kriasoft/Folder-Structure-Conventions) ):

<!--TREE_START-->
```
.
├── .IDE/                 # IDE / GIT / Editor / LSP related dot folders
├── .githooks/             # Git hooks files
├── deps/                 # `node_modules/`, `third_party/`, `.deps/` etc. - deps
├── build/                # Distribution/build files for end-user; not versioned in git
├── examples/             # 
├── doc/                  # Documentation files; both user and dev
├── src/                  # Source files (alternatively `lib` or `packages`)
├── packages/             # Sources per package; subfolders may replicate top-level structure
├── test/                 # Test files
├── tools/                # Dev-x executables / scripts / files
├── .file.xyz/            # Dev-x specific dotfiles
├── README.md
├── CONTRIBUTING.md
├── DEVELOPMENT.md
└── LICENSE
```
<!--TREE_END-->

<!--DEV_DEVELOP-->

#### TEMPLATE FILES
* `*.in`
<br/>files ending in `.in` usually mean a template file; this comes from C/C++ dev tools
<br/>e.g. `README.md.in` means template of a `README.md`

## BUILD
#### DEV DEPENDENCIES
* **[GNU Make](https://www.gnu.org/software/make/)** - required for `make` command; should be already installed on *nix systems <!--sc:gnu-make-->
* **[ts-vimdoc](https://github.com/ibhagwan/ts-vimdoc.nvim "tree-sitter based vimdoc generator")** - used to generate `doc/*.txt` files from `*.md` <!--devdeps:ts-vimdoc-->
* **[lua-language-server](https://github.com/LuaLS/lua-language-server)** - Lua LSP; LLS's lua doc annotations are based on EmmyLua; learn more [here](https://github.com/LuaLS/lua-language-server/wiki/Annotations) <!--devdeps:LLS-->
* **[git-hooks](https://git-scm.com/docs/.githooks)** - git hooks are used for automation; see folder `.githooks` <!--dev:git-hooks-->
<!--DEV_DEPS_DEV-->

#### RUNTIME DEPENDENCIES
<!-- TODO: [December 24, 2023] update build subsection -->
<!--DEV_DEPS_RUN-->

### ANY SYSTEM 
* `make -sr -C doc/ all` - run to build vim docs by using **ts-vimdoc**; dev dependencies are auto-bootstrapped. <!--dev:ts-vimdoc-->
<!--DEV_BUILD-->

## TEST
<!-- TODO: [December 24, 2023] update test subsection -->
<!--DEV_TEST-->

## PUBLISH
<!-- TODO: [December 24, 2023] update publish subsection -->
<!--DEV_PUBLISH-->

----
December 24, 2023</br>
Copyright © 2023 - Alexander Davronov (a.k.a. github@hinell), et.al.<br>
