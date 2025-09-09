if [[ $- != *i* ]]; then
  return
fi

export FZF_DEFAULT_OPTS='--color=16'
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GPG_TTY="$(tty)"
export NVM_DIR="${HOME}/.nvm"
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/.local/sbin:${PATH}"
export PROMPT_COMMAND='git-ps1'

if command -v /opt/homebrew/bin/brew > /dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
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

if command -v rustup > /dev/null; then
  if [[ -f "${HOME}/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
  fi
fi

if command -v fzf > /dev/null; then
  eval "$(fzf --bash)"
fi

if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
  source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
fi

if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/z.sh" ]]; then
  source "${HOMEBREW_PREFIX}/etc/profile.d/z.sh"
fi

alias be='bundle exec'
alias home='git --git-dir="${HOME}/.local/share/home" --work-tree="${HOME}"'
alias la='ls -A'
alias ls='ls -FGhl'

function git-ps1 {
  local PREFIX=$'\[\e[0;1;37;44m\] \W \[\e[0;34m\]\uE0B0\[\e[0m\]'
  local SUFFIX=$' '

  if [[ -n "${SSH_TTY}" ]]; then
    local PREFIX=$'\[\e[0;1;37;41m\] \u@\h \[\e[0;31;44m\]\uE0B0'"${PREFIX}"
  fi

  __git_ps1 "${PREFIX}" "${SUFFIX}"
}
