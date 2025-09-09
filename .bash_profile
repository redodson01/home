# shellcheck shell=bash

GPG_TTY="$(tty)"

export GPG_TTY
export NVM_DIR="${HOME}/.nvm"
export PATH="${HOME}/.local/bin:${PATH}"
export PROMPT_COMMAND='clean-history'

if command -v /opt/homebrew/bin/brew >/dev/null; then
  brew_shellenv="$(/opt/homebrew/bin/brew shellenv bash)"
  eval "${brew_shellenv}"
fi

if command -v rbenv >/dev/null; then
  rbenv_init="$(rbenv init - --no-rehash bash)"
  eval "${rbenv_init}"
fi

if command -v pyenv >/dev/null; then
  export PYENV_ROOT="${HOME}/.pyenv"
  if [[ -d "${PYENV_ROOT}/bin" ]]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
  fi
  pyenv_init="$(pyenv init - bash)"
  eval "${pyenv_init}"
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
    export PATH="${PATH}:${GOPATH}/bin"
  fi
fi

if command -v fzf >/dev/null; then
  fzf="$(fzf --bash)"
  eval "${fzf}"
fi

if [[ -r "${HOMEBREW_PREFIX:?}/etc/profile.d/bash_completion.sh" ]]; then
  # shellcheck source=/dev/null
  source "${HOMEBREW_PREFIX:?}/etc/profile.d/bash_completion.sh"
fi

if [[ -r "${HOMEBREW_PREFIX:?}/etc/profile.d/z.sh" ]]; then
  # shellcheck source=/dev/null
  source "${HOMEBREW_PREFIX:?}/etc/profile.d/z.sh"
fi

if command -v gh >/dev/null; then
  if GITHUB_PACKAGES_TOKEN="$(gh auth token)"; then
    export GITHUB_PACKAGES_TOKEN
  fi
fi

if CIRCLECI_TOKEN="$(security find-generic-password -a "${USER}" -s circleci-token -w)"; then
  export CIRCLECI_TOKEN
fi

function dedup-history {
  # shellcheck disable=SC2312
  sort -k2 -k1nr | uniq -f1 | sort -n | cut -c8-
}

function clean-history {
  history -a
  local hist
  hist="$(
    # shellcheck disable=SC2312
    sed -e 's/^[ ]*//' -e 's/[ ]*$//' -e '/^$/d' "${HISTFILE}" |
      nl |
      dedup-history
  )"
  echo "${hist}" >"${HISTFILE}"
  history -c
  history -r
}
