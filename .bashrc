# shellcheck shell=bash

if [[ $- != *i* ]]; then
  return
fi

GPG_TTY="$(tty)"

export FZF_DEFAULT_OPTS_FILE="${HOME}/.fzfrc"
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GPG_TTY
export NVM_DIR="${HOME}/.nvm"
export PATH="${HOME}/.local/bin:${PATH}"
export PROMPT_COMMAND='eval "$(command -v clean-history)"; eval "$(command -v git-ps1)"'

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

if command -v fzf >/dev/null; then
  fzf="$(fzf --bash)"
  eval "${fzf}"
else
  echo '.bashrc: fzf: command not found' >&2
fi

if [[ -r "${HOMEBREW_PREFIX:?}/etc/profile.d/bash_completion.sh" ]]; then
  # shellcheck source=/dev/null
  source "${HOMEBREW_PREFIX:?}/etc/profile.d/bash_completion.sh"
else
  echo ".bashrc: ${HOMEBREW_PREFIX:?}/etc/profile.d/bash_completion.sh: No such file or directory" >&2
fi

if [[ -r "${HOMEBREW_PREFIX:?}/etc/profile.d/z.sh" ]]; then
  # shellcheck source=/dev/null
  source "${HOMEBREW_PREFIX:?}/etc/profile.d/z.sh"
else
  echo ".bashrc: ${HOMEBREW_PREFIX:?}/etc/profile.d/z.sh: No such file or directory" >&2
fi

if command -v gh >/dev/null; then
  if GITHUB_PACKAGES_TOKEN="$(gh auth token)"; then
    export GITHUB_PACKAGES_TOKEN
  fi
else
  echo '.bashrc: gh: command not found' >&2
fi

if CIRCLECI_TOKEN="$(security find-generic-password -a "${USER}" -s circleci-token -w)"; then
  export CIRCLECI_TOKEN
fi

alias cls='clear && clear'
alias la='ls -A'
alias ls='ls -FGhl'

git_list_alias_git="$(git list-alias git)"
git_list_alias_home="$(git list-alias home)"

eval "${git_list_alias_git}"
eval "${git_list_alias_home}"

if [[ -n "${TMUX}" ]]; then
  function tmux-resize-panes {
    # shellcheck disable=SC2312
    tmux list-panes -a -F '#D' -f '#{!:#{window_zoomed_flag}}' |
      xargs -L 1 tmux select-layout -E -t
  }
  trap tmux-resize-panes WINCH
fi

function dedup-history {
  # shellcheck disable=SC2312
  sort -k2 -k1nr | uniq -f1 | sort -n | cut -c8-
}

function clean-history {
  history -a
  # shellcheck disable=SC2312
  sed -e '/^[ ]*$/d' -e 's/^[ ]*//' -e 's/[ ]*$//' "${HISTFILE}" |
    nl |
    dedup-history |
    sponge "${HISTFILE}"
  history -c
  history -r
}

function git-ps1 {
  local PREFIX=$'\[\\e[0;37;44m\] \W \[\\e[0;34m\]\uE0B0\[\\e[0m\]'
  local SUFFIX=$' $ '
  __git_ps1 "${PREFIX}" "${SUFFIX}"
}
