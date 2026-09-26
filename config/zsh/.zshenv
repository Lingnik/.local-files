########################################################################################################################
echo "`/opt/homebrew/bin/gdate +%s%3N` whoami=`whoami` tty=`tty` pid=$$ ppid=$PPID cmd=${0##*/} file=${${(%):-%N}//$HOME/~}" >> /Users/tm/log/zsh.log
if [[ -z "$CURSOR_AGENT" ]]; then
echo -n "DEBUG: ${${(%):-%N}//$HOME/~} :" && timing_ns=$(/opt/homebrew/bin/gdate +%s%3N)
echo -n "\t0 $((($(/opt/homebrew/bin/gdate +%s%3N) - timing_ns)))ms" && timing_ns=$(/opt/homebrew/bin/gdate +%s%3N)
fi
export Z_LOADED=$((${Z_LOADED:-0} + 1)); export Z_LOADED_${Z_LOADED}=${(%):-%N}
########################################################################################################################

# Cursor-specific debugging
if [[ -n "$CURSOR_AGENT" ]] || [[ -n "$CURSOR_TRACE_ID" ]]; then
  {
    echo "=== CURSOR DEBUG START ==="
    echo "Timestamp: $(/opt/homebrew/bin/gdate +%s%3N)"
    echo "PID: $$"
    echo "PPID: $PPID"
    echo "File: ${${(%):-%N}//$HOME/~}"
    echo "CURSOR_AGENT: ${CURSOR_AGENT:-unset}"
    echo "CURSOR_TRACE_ID: ${CURSOR_TRACE_ID:-unset}"
    echo "All CURSOR_* vars:"
    env | grep -i cursor || echo "  (none found)"
    echo "Shell: $SHELL"
    echo "ZSH_VERSION: $ZSH_VERSION"
    echo "Interactive: $([[ -o interactive ]] && echo yes || echo no)"
    echo "Login: $([[ -o login ]] && echo yes || echo no)"
    echo "TTY: $(tty 2>/dev/null || echo 'not a tty')"
    echo "Parent process: $(ps -p $PPID -o comm= 2>/dev/null || echo 'unknown')"
    echo "PWD: $PWD"
    echo "=== CURSOR DEBUG END ==="
  } >> /Users/tm/log/cursor-debug.log 2>&1
  
  # Trap errors to log them
  function cursor_error_trap() {
    {
      echo "=== CURSOR ERROR TRAP ==="
      echo "Timestamp: $(/opt/homebrew/bin/gdate +%s%3N)"
      echo "Error code: $?"
      echo "Line: $LINENO"
      echo "Command: $ZSH_DEBUG_CMD"
      echo "=== END ERROR ==="
    } >> /Users/tm/log/cursor-debug.log 2>&1
  }
  trap cursor_error_trap ERR
fi

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

# Work machine layer (gitignored): scripts, variables, and shell functions
[[ -d $HOME/.local/work/bin ]] && export PATH="$HOME/.local/work/bin:$PATH"
[[ -f $HOME/.local/work/env ]] && source $HOME/.local/work/env


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

    # Word-jump and line-jump with Opt/Cmd+Arrow (iTerm2 sends these escape sequences).
    bindkey '^[[1;3D' backward-word        # Opt+Left
    bindkey '^[[1;3C' forward-word         # Opt+Right
    bindkey '^[[1;9D' beginning-of-line    # Cmd+Opt+Left  (iff iTerm2 mapping is set)
    bindkey '^[[1;9C' end-of-line          # Cmd+Opt+Right (iff iTerm2 mapping is set)
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
    zgrep -rh -- "$@" "${ZSH_HISTORY_ARCHIVE:-$HOME/.local/state/zsh/history-archive}"
}
alias hg='hgrep'

# ls
alias ls='ls -1'

alias resource='source ~/.local/config/zsh/.zshrc'

alias op='/Users/tm/.local/bin/op-alert.sh'

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

[[ -f $HOME/.local/work/zshenv ]] && source $HOME/.local/work/zshenv

########################################################################################################################
[[ -z "$CURSOR_AGENT" ]] && echo "\tX $((($(/opt/homebrew/bin/gdate +%s%3N) - timing_ns)))ms :"

# Cursor-specific debugging at end of zshenv
if [[ -n "$CURSOR_AGENT" ]] || [[ -n "$CURSOR_TRACE_ID" ]]; then
  {
    echo "=== CURSOR DEBUG END OF ZSHENV ==="
    echo "Timestamp: $(/opt/homebrew/bin/gdate +%s%3N)"
    echo "Z_LOADED: $Z_LOADED"
    echo "PATH (first 5): $(echo $PATH | tr ':' '\n' | head -5 | tr '\n' ':')"
    echo "=== END ==="
  } >> /Users/tm/log/cursor-debug.log 2>&1
fi

# DO NOT ADD MORE LINES
########################################################################################################################
