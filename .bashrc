# shellcheck shell=bash

if [[ $- != *i* ]]; then
  return
fi

GPG_TTY="$(tty)"

export GPG_TTY
export PATH="${HOME}/.local/bin:${PATH}"

if command -v /opt/homebrew/bin/brew >/dev/null; then
  brew_shellenv="$(/opt/homebrew/bin/brew shellenv bash)"
  eval "${brew_shellenv}"
else
  echo '.bashrc: /opt/homebrew/bin/brew: command not found' >&2
fi
