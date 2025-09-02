# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt autocd beep
bindkey -v
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/whjang/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall

export EDITOR=vim
alias vim='nvim'

export MANPAGER='nvim +Man!'
export MANWIDTH=999

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1="%n@%m %1~ %# "

### Set up fzf key bindings and fuzzy completion
export FZF_CTRL_T_OPTS="--walker file,dir,hidden"
eval "$(fzf --zsh)"

# bind history to ctrl + h
bindkey '^H' fzf-history-widget

# custom fzf launcher
function fzf_launcher() {
  local cmd
  cmd=$(~/.local/bin/fzf-launcher.sh) || return
  LBUFFER+="$cmd "
  zle reset-prompt
}
zle -N fzf_launcher

# Bind it to Ctrl+R
bindkey '^R' fzf_launcher
