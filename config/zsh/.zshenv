########################################################################################################################
echo "`/opt/homebrew/bin/gdate +%s%3N` whoami=`whoami` tty=`tty` pid=$$ ppid=$PPID cmd=${0##*/} file=${${(%):-%N}//$HOME/~}" >> /Users/tm/log/zsh.log
echo -n "DEBUG> ${${(%):-%N}//$HOME/~} >" && timing_ns=$(/opt/homebrew/bin/gdate +%s%3N)
echo -n "\t0 $((($(/opt/homebrew/bin/gdate +%s%3N) - timing_ns)))ms" && timing_ns=$(/opt/homebrew/bin/gdate +%s%3N)
export Z_LOADED=$((${Z_LOADED:-0} + 1)); export Z_LOADED_${Z_LOADED}=${(%):-%N}
########################################################################################################################

export Z_PID_${Z_LOADED}=$$
export Z_PPID_${Z_LOADED}=$PPID
export Z_SHLVL_${Z_LOADED}=$SHLVL
export Z_DIAG_PID_${Z_LOADED}=$$
export Z_DIAG_PPID_${Z_LOADED}=$PPID
export Z_DIAG_SHLVL_${Z_LOADED}=$SHLVL
export Z_DIAG_CMD_${Z_LOADED}="$0"
export Z_DIAG_LOGIN_${Z_LOADED}=$([[ -o login ]] && echo Y || echo N)
export Z_DIAG_INTER_${Z_LOADED}=$([[ -o interactive ]] && echo Y || echo N)
export Z_DIAG_STDIN_${Z_LOADED}=$([[ -t 0 ]] && echo T || echo R)
export Z_DIAG_STDOUT_${Z_LOADED}=$([[ -t 1 ]] && echo T || echo R)
export Z_DIAG_PWD_${Z_LOADED}="$PWD"
export Z_DIAG_PARENT_${Z_LOADED}="$(ps -p $PPID -o comm= 2>/dev/null | head -c 50)"

export ZSH="$HOME/.local/share/oh-my-zsh"
ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 1
COMPLETION_WAITING_DOTS="true"
plugins=(git pyenv)

export LANG="en_US.UTF-8"
export EDITOR="nvim"



# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


if [[ "$OSTYPE" == "darwin"* ]]; then
  # Homebrew
  if [[ -a /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
  else
      echo "Homebrew might not be installed."
  fi

  # # OpenSSL
  # if [[ -d "$(brew --prefix)/opt/openssl@1.1/bin" ]]; then
  #     export PATH="$(brew --prefix)/opt/openssl@1.1/bin:$PATH"
  #     export LDFLAGS="-L$(brew --prefix)/opt/openssl@1.1/lib"
  #     export CPPFLAGS="-I$(brew --prefix)/opt/openssl@1.1/include"
  #     export PKG_CONFIG_PATH="$(brew --prefix)/opt/openssl@1.1/lib/pkgconfig"
  # else
  #     echo "OpenSSL might not be installed."
  # fi

  # # Visual Studio Code (`code`)
  #
  # if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]]; then
  #     export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  # else
  #     echo "Visual Studio Code might not be installed."
  # fi

  # Mac
  #command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

  # Ruby
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"

  # ???
  autoload -Uz compinit && compinit

  # Java
  # export JAVA_HOME="/Users/tmeek/.local/share/openjdk_11.0.21.0.101_11.69.14_aarch64"
  # if [[ -d "$JAVA_HOME" ]]; then
  #     export PATH=$JAVA_HOME/bin:$PATH
  # else
  #     echo "Java might not be installed."
  # fi

  # # Node
  # if [[ -d "/opt/homebrew/opt/node@18/bin" ]]; then
  #     export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
  #     export LDFLAGS="-L/opt/homebrew/opt/node@18/lib"
  #     export CPPFLAGS="-I/opt/homebrew/opt/node@18/include"
  # else
  #     echo "Node might not be installed."
  # fi

  # export PATH="/opt/homebrew/Cellar/pyenv-virtualenv/1.2.1/shims:${PATH}";
  # export PYENV_VIRTUALENV_INIT=1;
  # TEMP_PYENV_VIRTUALENV_PROJECT_DIR=$(mktemp /tmp/pyenv_virtualenv_project_dir_$(date +"%Y-%m-%d_%T"))
  #   _pyenv_virtualenv_hook() {
  #   local ret=$?
  #   project_dir=$(cat $TEMP_PYENV_VIRTUALENV_PROJECT_DIR)
  #   if [[ $project_dir == "" ]]; then
  #     if [ -f .python-version ] || [ -d venv ]; then
  #       echo $PWD > $TEMP_PYENV_VIRTUALENV_PROJECT_DIR
  #       eval "$(pyenv sh-activate --quiet || true)" || . venv/bin/activate 2> /dev/null || true
  #     fi
  #   elif [[ ! $PWD =~ $project_dir ]]; then
  #     echo > $TEMP_PYENV_VIRTUALENV_PROJECT_DIR
  #     eval "$(pyenv sh-deactivate --quiet || true)" || deactivate 2> /dev/null ||true
  #   fi
  #   return $ret
  # };
  # typeset -g -a precmd_functions
  # if [[ -z $precmd_functions[(r)_pyenv_virtualenv_hook] ]]; then
  #   precmd_functions=(_pyenv_virtualenv_hook $precmd_functions);
  # fi
  # function shellExit {
  #     rm "$TEMP_PYENV_VIRTUALENV_PROJECT_DIR" 2> /dev/nul
  # }
  # trap shellExit EXIT

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux
fi

if [[ -d "$XDG_DATA_HOME/pyenv" ]]; then
    export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
else
    echo "pyenv might not be installed"
fi

if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "$HOME/.local/bin is missing"
fi

[[ -a $HOME/.secrets ]] && source $HOME/.secrets


# Only run omz when interactive else Cursor will break
if [[ -o interactive ]]; then
  echo ""
  source $ZSH/oh-my-zsh.sh
fi

# git
export PROJECT_HOME=$HOME/git/
alias gs='git status'

# tmux
if [[ -o interactive ]]; then
    bindkey -s ^s "tmux-sessionizer\n"
fi
alias tls="tmux list-sessions"
alias ta="tmux attach -t"

# vim
alias vim="nvim"
alias vi="nvim"
alias vimdiff="nvim -d"
alias v="nvim"
alias pbv='vim -p `pbpaste|sort|uniq|f2p`'

# gpg
function encrypt() {
        output=~/"${1}".$(date +%s).enc
        gpg --encrypt --armor --output ${output} -r 0x11CD218F63C9B8F0 "${1}" && echo "${1} -> ${output}"
}
function decrypt() {
        output=$(echo "${1}" | rev | cut -c16- | rev)
        gpg --decrypt --output ${output} "${1}" && echo "${1} -> ${output}"
}

# SSH/GPG agent setup
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
if [[ -o interactive ]]; then
    export GPG_TTY="$(tty)"
    gpgconf --launch gpg-agent
    gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
fi

# SSH with YubiKey via gpg-agent

# grep
alias grep='grep --exclude-dir=target'
alias lgrep='grep -l'
function vgrep() {
        vim -p $(grep -l "$1" ${@})
}

# history grep
function hgrep() {
    zgrep -rh -- "$@" ~/git/a/tm-knowledge/zsh-history
}
alias hg='hgrep'

# ls
alias ls='ls -1'

alias resource='source ~/.local/config/zsh/.zshrc'

function bedrock() {
    export AWS_BEARER_TOKEN_BEDROCK=`op run -- aws-bedrock-token`
    exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        unset AWS_SESSION_TOKEN
    fi
    return $exit_code
}

source $HOME/.local/config/zsh/*_zshenv

########################################################################################################################
echo "\tX $((($(/opt/homebrew/bin/gdate +%s%3N) - timing_ns)))ms >"
# DO NOT ADD MORE LINES
########################################################################################################################
