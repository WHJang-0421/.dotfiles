export ZSH="$HOME/.oh-my-zsh" # Path to your Oh My Zsh installation.
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

### User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Add ~/.local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Add fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
