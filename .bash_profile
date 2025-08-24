# shellcheck shell=bash

if [[ -f "${HOME}/.bashrc" ]]; then
  source "${HOME}/.bashrc"
else
  echo ".bash_profile: ${HOME}/.bashrc: No such file or directory" >&2
fi
