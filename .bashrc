if [[ $- != *i* ]]; then
  return
fi

export GPG_TTY="$(tty)"

if command -v /opt/homebrew/bin/brew > /dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if command -v fzf > /dev/null; then
  eval "$(fzf --bash)"
fi

if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
  source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
fi

alias home='git --git-dir="${HOME}/.local/share/home" --work-tree="${HOME}"'
