#!/usr/bin/env bash
# shellcheck disable=SC2155
# shellcheck disable=SC2312

if [[ $- != *i* ]]; then
  return
fi

export FZF_DEFAULT_OPTS_FILE="${HOME}/.fzfrc"
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GPG_TTY="$(tty)"
export HOMEBREW_PREFIX=/opt/homebrew
export NVM_DIR="${HOME}/.nvm"
export PATH="${HOME}/.local/bin:${PATH}"
export PROMPT_COMMAND='git-ps1'

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

# shellcheck disable=SC2250
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # shellcheck source=/dev/null
  source "$NVM_DIR/nvm.sh"
fi

# shellcheck disable=SC2250
if [[ -s "$NVM_DIR/bash_completion" ]]; then
  # shellcheck source=/dev/null
  source "$NVM_DIR/bash_completion"
fi

if [[ -f "${HOME}/.cargo/env" ]]; then
  # shellcheck source=/dev/null
  source "${HOME}/.cargo/env"
fi

if command -v go >/dev/null; then
  export GOPATH="${HOME}/.go"

  if [[ -d "${GOPATH}/bin" ]]; then
    export PATH="${GOPATH}/bin:${PATH}"
  fi
fi

if command -v fzf >/dev/null; then
  eval "$(fzf --bash)"
fi

if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
  # shellcheck source=/dev/null
  source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
fi

if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/z.sh" ]]; then
  # shellcheck source=/dev/null
  source "${HOMEBREW_PREFIX}/etc/profile.d/z.sh"
fi

alias home='git --git-dir="${HOME}/.local/share/home" --work-tree="${HOME}"'
alias la='ls -A'
alias ls='ls -FGhl'
alias watch='hwatch --color --no-title --use-pty --limit 10'

function git-ps1 {
  local PREFIX=$'\[\\e[0;37;44m\] \W \[\\e[0;34m\]\uE0B0\[\\e[0m\]'
  local SUFFIX=$' $ '

  __git_ps1 "${PREFIX}" "${SUFFIX}"
}
