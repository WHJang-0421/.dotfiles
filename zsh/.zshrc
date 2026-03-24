export ZSH="$HOME/.oh-my-zsh" # Path to your Oh My Zsh installation.
ZSH_THEME="robbyrussell"
plugins=(git zsh-vi-mode)
source $ZSH/oh-my-zsh.sh

export PATH="/usr/sbin:/home/whjang/.local/bin/:$PATH"
export ANDROID_HOME="/home/whjang/Android/Sdk/"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

### User configuration

alias nv='nvim-linux-x86_64.appimage'
export EDITOR=nv

# Add fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/whjang/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/whjang/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/whjang/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/whjang/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

gcc800() {
    gcc -Wall -Werror -pedantic -std=c99 "$@"
}

if [[ "$TERM" == "xterm-kitty" ]]; then
    alias ssh="kitty +kitten ssh"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
