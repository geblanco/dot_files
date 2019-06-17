alias subl='/opt/sublime_text/sublime_text'
alias dev="cd ~/Documents/Dev/"
alias res="cd ~/Documents/Research/"
# done by script in bin
# alias pbCopy='xclip -sel clip'
# alias pbPaste='xclip -o -sel clip'
alias getclip='xclip -o --sel | pbcopy'
exo='exo-open'
hash exo-open 2>/dev/null
if [[ $? -eq 1 ]]; then
  exo='xdg-open'
fi

alias open='$exo '
alias you-dl='youtube-dl -xi --yes-playlist --audio-format "wav" -o "%(title)s.%(ext)s"'
alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'

export NODE_PATH='$HOME/.npm-global/lib/node_modules'
export GZIP=-9
export XZ_OPT=-9

# custom scripts
export PATH=/opt/scripts/:$PATH
# npm global path (fix permissions)
export PATH="$HOME/.npm-global/bin:$PATH"
# ruby gems
export PATH="/home/gb/.gem/ruby/2.5.0/bin:$PATH"

# Servers config
if [[ -f ~/.config/servers ]]; then
  source ~/.config/servers
fi

# gtd config
if [[ -f $HOME/.gtd_aliases ]]; then
  source $HOME/.gtd_aliases
fi

export PYTHONSTARTUP="$HOME/.pythonrc"
export NODE_PATH='/home/gb/.npm-global/lib/node_modules'
export TF_CPP_MIN_LOG_LEVEL=3

export VISUAL="vim"

_telegram() {
  local cmd=$1; shift
  local msg=""
  for file in $@; do
    msg="$cmd Guille $file"
    telegram-cli --exec $msg --disable-output
  done
}

backup() {
  _telegram "send_file" $@
}

msg() {
  _telegram "msg" $@
}

_enter_python() {
  local arg=$1; shift
  local cwd=$(pwd)
  local cmd="cd $cwd"
  local work_dir="$HOME/Documents/Dev/python_data_science/"
  if [[ $# -gt 0 ]]; then
    work_dir=$1
  fi
  cd $work_dir
  if [[ "$arg" == "ipython" ]]; then
    cmd+=" && ipython"
  fi
  pipenv shell "$cmd"; cd $cwd
}

env_ipython() {
  _enter_python "ipython" $@
}

env_shell() {
  _enter_python "shell" $@
}

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  ssh-agent -s -D -a $XDG_RUNTIME_DIR/ssh-agent.socket > ~/.config/ssh-agent-data
else
  export SSH_AGENT_PID=$(pgrep -u "$USER" -ao ssh-agent | cut -f 1 -d ' ')
  export SSH_AUTH_SOCK=$(pgrep -u "$USER" -ao ssh-agent | awk '{print $(NF)}')
fi

init-nvm() {
  [ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
  source /usr/share/nvm/nvm.sh
  source /usr/share/nvm/bash_completion
  source /usr/share/nvm/install-nvm-exec
}

