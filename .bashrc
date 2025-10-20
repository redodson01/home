if [[ $- != *i* ]]; then
  return
fi

export GPG_TTY="$(tty)"

if command -v /opt/homebrew/bin/brew > /dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if command -v rbenv > /dev/null; then
  eval "$(rbenv init - --no-rehash bash)"
fi

alias home='git --git-dir="${HOME}/.local/share/home" --work-tree="${HOME}"'
