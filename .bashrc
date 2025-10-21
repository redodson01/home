if [[ $- != *i* ]]; then
  return
fi

export GPG_TTY="$(tty)"
export NVM_DIR="${HOME}/.nvm"
export PATH="${HOME}/.local/bin:${PATH}"

if command -v /opt/homebrew/bin/brew > /dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv bash)"
fi

if command -v rbenv > /dev/null; then
  eval "$(rbenv init - --no-rehash bash)"
fi

if command -v pyenv > /dev/null; then
  export PYENV_ROOT="${HOME}/.pyenv"

  if [[ -d "${PYENV_ROOT}/bin" ]]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
  fi

  eval "$(pyenv init - bash)"
fi

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi

if [[ -s "$NVM_DIR/bash_completion" ]]; then
  source "$NVM_DIR/bash_completion"
fi

if [[ -f "${HOME}/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

alias home='git --git-dir="${HOME}/.local/share/home" --work-tree="${HOME}"'
