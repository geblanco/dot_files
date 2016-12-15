
export PS1='-\[\033[01;32m\][\u@\h\[\033[01;37m\] - \t - [\033[01;32m\]\W\[\033[00m\]]\n\[\033[01;32m\]]\$\[\033[00m\] '
export PS1='-\[\033[01;32m\][\u@\h\[\033[01;37m\] - \t - \W]\n\[\033[01;32m\]]\$\[\033[00m\] '
export PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\n|-\$\[\033[00m\] '
alias subl='subl3'
alias dev='cd ~/Documents/Dev'
alias tfg='cd ~/Documents/TFG && source ./pkgs/sim_vars.sh'
alias pbCopy='xclip -sel clip'
alias pbPaste='xclip -o -sel clip'
export NODE_PATH='/home/gb/.npm-global/lib/node_modules'

# Servers config
[[ -f ~/.config/servers ]] && source ~/.config/servers

alias open='exo-open '
alias NTILDE='xkbcomp -w 0 /home/gb/.config/xkbmap $DISPLAY'

alias getClip='xclip -o --sel | pbCopy'
export PATH=/opt/scripts/:$PATH

export GZIP=-9
export XZ_OPT=-9
alias you-dl='youtube-dl -xi --yes-playlist --audio-format "wav" -o "%(title)s.%(ext)s"'

# npm global path (fix permissions)
export PATH="~/.npm-global/bin:$PATH"

# This will change your title to the last command run, 
# and make sure your history file is always up-to-date:
export HISTCONTROL=ignoreboth
export HISTIGNORE='history*':$HISTIGNORE
export PROMPT_COMMAND='history -a;echo -en "\e]2;";history 1|sed "s/^[ \t]*[0-9]\{1,\}  //g";echo -en "\e\\"; source ~/.config/sh_theme;'

alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'

# Load theme
[[ -f ~/.config/sh_theme ]] && source ~/.config/sh_theme
