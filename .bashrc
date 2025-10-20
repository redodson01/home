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

if command -v rbenv >/dev/null; then
  eval "$(rbenv init - --no-rehash bash)"
fi

if command -v pyenv >/dev/null; then
  export PYENV_ROOT="${HOME}/.pyenv"

  if [[ -d "${PYENV_ROOT}/bin" ]]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
  fi

  eval "$(pyenv init - bash)"
fi

alias home='git --git-dir="${HOME}/.local/share/home" --work-tree="${HOME}"'
