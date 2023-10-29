#!/usr/bin/bash
echo -en "$0: configuring git... "
git config core.hooksPath ".githooks"
echo -e "$(tput setaf 2)done!$(tput op)"
