if [[ $- != *i* ]]; then
  return
fi

export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export PATH="${HOME}/.local/bin:${PATH}"
export PROMPT_COMMAND='git-ps1'

if command -v /opt/homebrew/bin/brew > /dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
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

alias home='git --git-dir="${HOME}/.local/share/home" --work-tree="${HOME}"'
alias la='ls -A'
alias ls='ls -FGhl'

function git-ps1 {
  __git_ps1 $'\[\e[0;1;37;44m\] \W \[\e[0;34m\]\uE0B0\[\e[0m\]' $' '
}
