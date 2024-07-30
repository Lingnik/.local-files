########################################################################################################################
echo -n "\ue615 ${${(%):-%N}//$HOME/~} \uf251" && timing_ns=$(/opt/homebrew/bin/gdate +%s%3N)
echo -n "\t0 $((($(/opt/homebrew/bin/gdate +%s%3N) - timing_ns)))ms" && timing_ns=$(/opt/homebrew/bin/gdate +%s%3N)
########################################################################################################################

# OS-specific things
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Homebrew
  if [[ -a /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
  else
      echo "Homebrew might not be installed."
  fi

  # OpenSSL
  if [[ -d "$(brew --prefix)/opt/openssl@1.1/bin" ]]; then
      export PATH="$(brew --prefix)/opt/openssl@1.1/bin:$PATH"
      export LDFLAGS="-L$(brew --prefix)/opt/openssl@1.1/lib"
      export CPPFLAGS="-I$(brew --prefix)/opt/openssl@1.1/include"
      export PKG_CONFIG_PATH="$(brew --prefix)/opt/openssl@1.1/lib/pkgconfig"
  else
      echo "OpenSSL might not be installed."
  fi

  # Visual Studio Code (`code`)

  if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]]; then
      export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  else
      echo "Visual Studio Code might not be installed."
  fi

  # Mac
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

  # Java
  export JAVA_HOME="/Users/tmeek/.local/share/openjdk_11.0.21.0.101_11.69.14_aarch64"
  if [[ -d "$JAVA_HOME" ]]; then
      export PATH=$JAVA_HOME/bin:$PATH
  else
      echo "Java might not be installed."
  fi

  # Node
  if [[ -d "/opt/homebrew/opt/node@18/bin" ]]; then
      export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
      export LDFLAGS="-L/opt/homebrew/opt/node@18/lib"
      export CPPFLAGS="-I/opt/homebrew/opt/node@18/include"
  else
      echo "Node might not be installed."
  fi

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
    export PATH="$PATH:$HOME/.local/bin"
else
    echo "$HOME/.local/bin is missing"
fi

export LANG="en_US.UTF-8"
export EDITOR="nvim"

# zsh
export ZSH_THEME="kafeitu"
zstyle ':omz:update' mode auto
zstyle ':omz:update' verbose minimal
setopt EXTENDED_HISTORY
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE

[[ -a $HOME/.secrets ]] && source $HOME/.secrets


########################################################################################################################
echo "\tX $((($(/opt/homebrew/bin/gdate +%s%3N) - timing_ns)))ms \uf253"
# DO NOT ADD MORE LINES
########################################################################################################################
