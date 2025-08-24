#!/usr/bin/env bash
# shellcheck disable=SC2155
# shellcheck disable=SC2312

if [[ $- != *i* ]]; then
  return
fi

export GPG_TTY="$(tty)"
export HOMEBREW_PREFIX=/opt/homebrew
export PATH="${HOME}/.local/bin:${PATH}"

if command -v "${HOMEBREW_PREFIX}/bin/brew" >/dev/null; then
  eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv bash)"
fi

alias home='git --git-dir="${HOME}/.local/share/home" --work-tree="${HOME}"'
