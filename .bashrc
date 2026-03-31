# shellcheck shell=bash

if [[ $- != *i* ]]; then
  return
fi

GPG_TTY="$(tty)"

export GPG_TTY
export NVM_DIR="${HOME}/.nvm"
export PATH="${HOME}/.local/bin:${PATH}"

if command -v /opt/homebrew/bin/brew >/dev/null; then
  brew_shellenv="$(/opt/homebrew/bin/brew shellenv bash)"
  eval "${brew_shellenv}"
else
  echo '.bashrc: /opt/homebrew/bin/brew: command not found' >&2
fi

if command -v rbenv >/dev/null; then
  rbenv_init="$(rbenv init - --no-rehash bash)"
  eval "${rbenv_init}"
else
  echo '.bashrc: rbenv: command not found' >&2
fi

if command -v pyenv >/dev/null; then
  export PYENV_ROOT="${HOME}/.pyenv"
  if [[ -d "${PYENV_ROOT}/bin" ]]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
  fi
  pyenv_init="$(pyenv init - bash)"
  eval "${pyenv_init}"
else
  echo '.bashrc: pyenv: command not found' >&2
fi

# shellcheck disable=SC2250
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # shellcheck source=/dev/null
  source "$NVM_DIR/nvm.sh"
else
  echo ".bashrc: $NVM_DIR/nvm.sh: No such file or directory" >&2
fi

# shellcheck disable=SC2250
if [[ -s "$NVM_DIR/bash_completion" ]]; then
  # shellcheck source=/dev/null
  source "$NVM_DIR/bash_completion"
else
  echo ".bashrc: $NVM_DIR/bash_completion: No such file or directory" >&2
fi

if [[ -f "${HOME}/.cargo/env" ]]; then
  # shellcheck source=/dev/null
  source "${HOME}/.cargo/env"
else
  echo ".bashrc: ${HOME}/.cargo/env: No such file or directory" >&2
fi

if command -v go >/dev/null; then
  export GOPATH="${HOME}/.go"
  if [[ -d "${GOPATH}/bin" ]]; then
    export PATH="${PATH}:${GOPATH}/bin"
  fi
else
  echo '.bashrc: go: command not found' >&2
fi
