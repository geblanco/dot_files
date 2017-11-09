alias subl='/opt/sublime_text/sublime_text'
alias dev="cd ~/Documents/Dev/"
alias master="cd ~/Documents/AIMaster/Curso/"
# done by script in bin
#alias pbCopy='xclip -sel clip'
#alias pbPaste='xclip -o -sel clip'
alias getClip='xclip -o --sel | pbCopy'
alias open='exo-open '
alias you-dl='youtube-dl -xi --yes-playlist --audio-format "wav" -o "%(title)s.%(ext)s"'
alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'

export NODE_PATH='$HOME/.npm-global/lib/node_modules'
export GZIP=-9
export XZ_OPT=-9

# custom scripts
export PATH=/opt/scripts/:$PATH
# npm global path (fix permissions)
export PATH="$HOME/.npm-global/bin:$PATH"
# ruby gems global path
export PATH="$HOME/.gem/ruby/2.4.0/bin:$PATH"

# Servers config
[[ -f $HOME/.config/servers ]] && source $HOME/.config/servers

export PYTHONSTARTUP="$HOME/.pythonrc"
export NODE_PATH='/home/gb/.npm-global/lib/node_modules'
export TF_CPP_MIN_LOG_LEVEL=3

export VISUAL="vim"
