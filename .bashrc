if [[ $- != *i* ]]; then
  return
fi

export PATH="${HOME}/.local/bin:${PATH}"

if command -v /opt/homebrew/bin/brew > /dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

alias home='git --git-dir="${HOME}/.local/share/home" --work-tree="${HOME}"'
